-- config.lua file must be in /home/lib/ directory
local config = require("config")
local logging = require("logging")
--------------------------------
local tests = {}
local Assert = {}
local logger = logging.getLogger("./tests.log")
--------------------------------
local function deepEqual(table1, table2)
  for key in pairs(table1) do
    --if table1[key] ~= table2[key] then
    --  return false
    --end
    if type(table1[key]) == "table" and type(table1[key]) == type(table2[key]) then
      deepEqual(table1[key], table2[key])
    else
      assert(table1[key], table2[key])
    end
  end
  for key in pairs(table2) do
    --if table1[key] ~= table2[key] then
    --  return false
    --end
    if type(table1[key]) == "table" and type(table1[key]) == type(table2[key]) then
      deepEqual(table1[key], table2[key])
    else
      assert(table1[key], table2[key])
    end
  end
  return true
end

function Assert.equal(a, b)
  logger:debug(("CALLED Assert.equal(%s, %s)"):format(a, b))
  if a == b then
    logger:debug("Assert.equal RETURNS true")
    return true
  elseif type(a) == "table" and type(a) == type(b) then
    deepEqual(a, b)
  else
    local result = a == b
    logger:debug(("Assert.equal RETURNS %s"):format(result))
    return result
  end
end
--------------------------------
---- Standards (true values)
--local NAME = "Kirill"
--local WEIGHT = 70
--------------------------------
tests = {
  function()
    -- Standards (true values)
    local NAME = "Kirill"
    local WEIGHT = 70
    --
    local parser = config.TableParser("./tables_1.cfg")
    local name = parser:get("name")
    local weight = parser:get("weight")
    assert(name == NAME)
    assert(weight == WEIGHT)
  end,
  function()
    -- Standards (true values)
    local NAME = "Kirill"
    local WEIGHT = 70
    --
    local parser = config.TableParser("./tables_1.cfg")
    local name = parser:get("name")
    local weight = parser:get("weight")
    assert(name == NAME)
    assert(weight == WEIGHT)
    name = parser:get("name")
    assert(name == NAME)
    name = parser:get("name")
    assert(name == NAME)
  end,
  function()
    -- Standards (true values)
    local NAME = "Kirgus"
    local IS_NAZI = nil
    local LANGUAGES = {"english", "c", "c++", "python", "lua", "sql", "bash"}
    --
    logger:debug("Test 3 | STARTED")
    local parser = config.TableParser("./tables_2.cfg")
    local name = parser:get("name")
    local isNazi = parser:get("isNazi")
    local languages = parser:get("languages")
    logger:debug("Test 3 | ALL KEYS GOT")
    logger:debug(("Test 3 | DO assert(%s == %s)"):format(name, NAME))
    assert(name == NAME)
    logger:debug(("Test 3 | DO assert(%s == %s)"):format(isNazi, IS_NAZI))
    assert(isNazi == IS_NAZI)
    logger:debug(("Test 3 | DO assert(%s == %s)"):format(languages, LANGUAGES))
    --L1 = languages
    --L2 = LANGUAGES
    Assert.equal(languages, LANGUAGES)
    logger:debug("Test 3 | FINISHED AND PASSED")
  end
}
--------------------------------
logger:debug("Tests started")
local testsTotal = #tests
local testsPassed = 0
for i = 1, #tests do
  local passed, err = pcall(tests[i])
  if passed then
    testsPassed = testsPassed + 1
    print(("Test #%d PASSED"):format(i))
    logger:debug(("Test #%d PASSED"):format(i))
  else
    print(("Test #%d FAILED"):format(i))
    logger:debug(("Test #%d FAILED | %s"):format(i, err))
  end
end

if testsTotal == testsPassed then
  print("All tests passed")
elseif testsPassed > 0 then
  print(("%d tests passed, %d tests failed"):format(testsPassed, testsTotal - testsPassed))
elseif testsPassed == 0 and testsTotal > 0 then
  print("All tests failed")
else
  print("There is no tests")
end
logger:debug("Tests finished")