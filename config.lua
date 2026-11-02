-- ConfigLib github.com/GusarevKirill/OC-ConfigLib
-- Configuration library for OpenComputers by Kirgus
local lib = {}
local TableParser = {}
--------------------------------
local function shallowCopy(tbl)
  local copy = {}
  for key, value in pairs(tbl) do
    copy[key] = value
  end
  return copy
end
--------------------------------
---- TableParser
function TableParser.get(self, key)
  local tableStr
  local f = io.open(self._path, "r")
  local content = f:read("*a")
  f:close()
  content = content:gsub("^%s+", "")  -- Stripping at beginning
  --if content:find("[_%a]") == 1 then
  if content:sub(1, 1):match("[_%a]") then
    tableStr = content:match("=%s*(.+)")
  elseif content:sub(1, 1) == "{" then
    tableStr = content
  else
    error("Invalid format (table expected)")
  end
  --self._table, err = load("return " .. tableStr)()
  local loadedTableFunc, err = load("return " .. tableStr)
  if err then
    return nil, err
  else
    self._table = loadedTableFunc()
    local value = self._table[key]
    return value
  end
end

function lib.TableParser(path)
  --local parser = {
  --  _path = path,
  --  get = get,
  --}
  local parser = shallowCopy(TableParser)
  parser._path = path
  return parser
end
---- /TableParser
--------------------------------
return lib