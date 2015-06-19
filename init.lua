local framework = require('framework')
local CommandOutputDataSource = framework.CommandOutputDataSource
local PollerCollection = framework.PollerCollection
local DataSourcePoller = framework.DataSourcePoller
local Plugin = framework.Plugin
local os = require('os')
local table = require('table')
local string = require('string')

local isEmpty = framework.string.isEmpty
local clone = framework.table.clone

local params = framework.params 

local HOST_IS_DOWN = -1

-- Define a map of platform to ping commands
local commands = {
  linux = { path = '/bin/ping', args = {'-n', '-w 2', '-c 1'} },
  win32 = { path = 'C:/windows/system32/ping.exe', args = {'-n', '1', '-w', '3000'} },
  darwin = { path = '/sbin/ping', args = {'-n', '-t 2', '-c 1'} }
}

-- Lookup the ping command to use based on the platform we are running on
local ping_command = commands[string.lower(os.type())]

-- If we do not support this platform then emit an error and exit
if ping_command == nil then
  print("_bevent:"..(Plugin.name or params.name)..":"..(Plugin.version or params.version)..":Your platform is not supported.  We currently support Linux, Windows and OSX|t:error|tags:lua,plugin"..(Plugin.tags and framework.string.concat(Plugin.tags, ',') or params.tags))
  process:exit(-1)
end

-- Creates a poller for each item in our plugin parameter list in param.json
local function createPollers (params, cmd) 
  local pollers = PollerCollection:new() 
  for _, item in ipairs(params.items) do
    local cmd = clone(cmd)
    table.insert(cmd.args, item.host)
    cmd.info = item.source
    cmd.callback_on_errors = true

    local data_source = CommandOutputDataSource:new(cmd)
    local poll_interval = tonumber(item.pollInterval or params.pollInterval) * 1000
    local poller = DataSourcePoller:new(poll_interval, data_source)
    pollers:add(poller)
  end

  return pollers
end

local function parseOutput(context, output) 
  
  assert(output ~= nil, 'parseOutput expect some data')

  if isEmpty(output) then
    context:emit('error', 'Unable to obtain any output.')
    return HOST_IS_DOWN
  end

  if (string.find(output, "unknown host") or string.find(output, "could not find host.")) then
    context:emit('error', 'The host ' .. context.args[#context.args] .. ' was not found.')
    return HOST_IS_DOWN
  end

  local index
  local prevIndex = 0
  while true do
    index = string.find(output, '\n', prevIndex+1) 
    if not index then break end

    local line = string.sub(output, prevIndex, index-1)
    local _, _, time  = string.find(line, "time=([0-9]*%.?[0-9]+)")
    if time then 
      return tonumber(time)
    end
    prevIndex = index
  end

  return HOST_IS_DOWN 
end

local pollers = createPollers(params, ping_command)
local plugin = Plugin:new(params, pollers)

function plugin:onParseValues(data) 
  local result = {}

  local value = parseOutput(self, data['output'])
  result['PING_RESPONSETIME'] = { value = value, source = data['info'] }
  return result
end

plugin:run()
