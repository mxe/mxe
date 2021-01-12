local function round(x)
    return math.floor(x + 0.5)
end

local pkg2sum = {}
local pkg2n = {}

for line in io.stdin:lines() do
    if line:match("%[done%]") then
        local _, pkg, _, _, time = assert(line:match("(%[done%]) +([^ ]+) +([^ ]+) +([^ ]+) KiB +([^ ]+)"))
        local minutes, seconds = assert(time:match("(%d+)m([%d%.]+)"))
        local total_seconds = minutes * 60 + seconds
        pkg2sum[pkg] = (pkg2sum[pkg] or 0) + total_seconds
        pkg2n[pkg] = (pkg2n[pkg] or 0) + 1
    end
end

local pkg2avg = {}
for pkg, sum in pairs(pkg2sum) do
    local n = assert(pkg2n[pkg])
    local avg = sum / n
    pkg2avg[pkg] = avg
    --print(avg)
end

local sum = 0
local n = 0
for pkg, time in pairs(pkg2avg) do
    sum = sum + time
    n = n + 1
end

local AVG1 = sum / n
print("Average: " .. AVG1)

local MIN_FACTOR = 3.0

local sum2 = 0
local n2 = 0
for pkg, time in pairs(pkg2avg) do
    local factor = time / AVG1
    if factor < MIN_FACTOR then
        sum2 = sum2 + time
        n2 = n2 + 1
    end
end

local AVG2 = sum2 / n2
local max_factor = 0

local factor2pkgs = {}
for pkg, time in pairs(pkg2avg) do
    local factor = time / AVG1
    if factor >= MIN_FACTOR then
        local factor2 = round(time / AVG2)
        factor2pkgs[factor2] = factor2pkgs[factor2] or {}
        table.insert(factor2pkgs[factor2], '"' .. pkg .. '"')
        max_factor = math.max(max_factor, factor2)
    end
end

local MIN_GROUP = 3

-- group
local group = {}
local sum = 0
local factor2pkgs2 = {}
for factor = 0, max_factor do
    local pkgs = factor2pkgs[factor]
    if pkgs then
        for _, pkg in ipairs(pkgs) do
            table.insert(group, pkg)
            sum = sum + factor
        end
        if #group >= MIN_GROUP or factor == max_factor then
            local factor3 = round(sum / #group)
            assert(not factor2pkgs2[factor3])
            factor2pkgs2[factor3] = group
            sum = 0
            group = {}
        end
    end
end

print("local HUGE_TIMES = {")
for factor = 0, max_factor do
    local pkgs = factor2pkgs2[factor]
    if pkgs then
        print(("[%d] = {%s},"):format(factor, table.concat(pkgs, ', ')))
    end
end
print("}")
