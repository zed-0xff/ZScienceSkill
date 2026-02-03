#!/bin/bash
# Spec runner for ZScienceSkill via game API server
# Requires:
#   - ZombieBuddy mod installed
#   - lua_server_port option enabled
#   - Game running with API server on port 4444

API_URL="http://127.0.0.1:4444/lua?depth=5"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🧪 Testing ZScienceSkill via Game API"
echo "======================================"
echo

# Helper function to execute Lua and get result
exec_lua() {
    curl -s -X POST "$API_URL" -d "$1"
}

# Spec 1: Verify mod is loaded
echo -n "Spec 1: Mod data loaded... "
result=$(exec_lua "return ZScienceSkill and ZScienceSkill.literature ~= nil")
if [[ "$result" == "true" ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "  Expected: true, Got: $result"
fi

# Spec 2: Science book XP value
echo -n "Spec 2: Science book XP = 35... "
result=$(exec_lua "return ZScienceSkill.literature['Base.Book_Science']")
if [[ "$result" == "35" ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "  Expected: 35, Got: $result"
fi

# Spec 3: Brain specimen XP = 60 (double base)
echo -n "Spec 3: Brain specimen XP = 60... "
result=$(exec_lua "return ZScienceSkill.specimens['Base.Specimen_Brain']")
if [[ "$result" == "60" ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "  Expected: 60, Got: $result"
fi

# Spec 4: Count herbalist plants
echo -n "Spec 4: Herbalist plants >= 10... "
result=$(exec_lua "local count = 0; for _ in pairs(ZScienceSkill.herbalistPlants) do count = count + 1 end; return count")
if [[ "$result" -ge 10 ]]; then
    echo -e "${GREEN}✓ PASS${NC} ($result plants)"
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "  Expected: >= 10, Got: $result"
fi

# Spec 5: Verify all specimens have positive XP
echo -n "Spec 5: All specimens have XP > 0... "
result=$(exec_lua "
    for item, xp in pairs(ZScienceSkill.specimens) do
        if type(xp) ~= 'number' or xp <= 0 then
            return false
        end
    end
    return true
")
if [[ "$result" == "true" ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Spec 6: Check player can access mod data
echo -n "Spec 6: Player can access mod... "
result=$(exec_lua "
    local player = getPlayer()
    if not player then return 'no_player' end
    return ZScienceSkill ~= nil
")
if [[ "$result" == "true" ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
elif [[ "$result" == "\"no_player\"" ]]; then
    echo -e "${YELLOW}⊘ SKIP${NC} (no player in game)"
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Spec 7: ISResearchSpecimen class exists
echo -n "Spec 7: Research action class loaded... "
result=$(exec_lua "return ISResearchSpecimen ~= nil")
if [[ "$result" == "true" ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Spec 8: Fluid research data
echo -n "Spec 8: SecretFlavoring XP = 200... "
result=$(exec_lua "return ZScienceSkill.fluids['SecretFlavoring'] and ZScienceSkill.fluids['SecretFlavoring'].Science")
if [[ "$result" == "200" ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "  Expected: 200, Got: $result"
fi

echo
echo "======================================"
echo "Specs completed!"
