# Contributing

Thank you for your interest in contributing to this repository!

This document provides guidelines and instructions to help make the process as smooth as possible. It applies to all types of contributions, including but not limited to bug reports, pull requests, feature requests, and more.

# Guidelines

To maintain quality and consistency, please follow the guidelines below. Contributions that do not follow these guidelines may be declined.

- Treat everyone with respect and use common sense.
- Search existing issues before creating a new one.
- Clearly describe your issue or proposed changes, including all relevant details.
- Provide steps to reproduce bugs when applicable.
- Keep discussions focused and constructive.

### Additional guidelines for pull requests
- Keep each pull request focused on a single purpose. Do not combine unrelated changes into one pull request.
- Ensure your changes are stable and do not introduce new issues or break existing functionality.
- Follow the coding standards described in the section below.
- Keep commit messages concise and relevant to the changes made.
- Make sure your branch is up to date with the target branch before submitting.

# Coding Standards

To keep the codebase clean and maintainable, please follow the guidelines below.

- Follow the existing code style and structure.
- Use clear and descriptive variable and function names.
- Avoid unnecessary comments, unused code, or redundant changes.
- Ensure proper indentation and consistent formatting.

### Formatting
- **Indentation:**
  - Use `Tab` characters. Do not use spaces!
  - All code must be indented correctly according to its scope.
    ```lua
    function ENT:GetAmmo()
    	return self:GetActiveWeapon():Ammo1()
    end
    ```
- **Naming Conventions:**
  - Local variables and functions use lowerCamelCase.
    ```lua
    local seenEnemy = false
    local function seenEnemy() end
    ```
  - Global variables and functions use UpperCamelCase.
    ```lua
    SeenEnemy = false
    function SeenEnemy() end
    ```
  - Parameters use lowerCamelCase.
    ```lua
    function GetDistance(eyePos, targetPos) end
    ```
- **Operators and Expressions:**
  - Put spaces around operators and after separators.
    ```lua
    SomeTable = {"hello", "hi", "hey"}
    CoolNum = 1 + (((2 * 2) / 2) - (1 + 1))
    ```
  - Do not put spaces inside brackets.
    ```lua
    MyPos = self:GetPos() + (6 / (3 - 1))
    ```
  - Use Garry's Mod C-style NOT operators (`!`, `!=`) instead of Lua's `not` operator.
    ```lua
    if dist != 100 and !self:HasEnemy() then
    ```
  - Use the minimum number of grouping brackets necessary, including for logical operators (OR, AND, NOT, etc.)
    ```lua
    if (hasTarget and !seenEnemy) or isHit then
    
    if hasTarget and (!seenEnemy or isHit) then
    
    if hasTarget and !seenEnemy and isHit then
    ```
  - End unassigned declarations with a semicolon (`;`).
    ```lua
    local someVar;
    someVar = 1 + 1
    ```
- **Comments:**
  - Take advantage of Garry's Mod comment aliases to differentiate between comment types.
  - For commented-out (disabled) code, use `//` or `/* */`.
    ```lua
    local someNum = 1 + 2
    // someNum - otherNum
    ```
  - For inline or explanatory comments, use `--` or `--[[ ]]`.
    ```lua
    local totalDist = myDist + targetDist -- Add my distance with the target to get the total distance
    ```