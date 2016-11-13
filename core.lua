-- luacheck: globals NeP
local CK                      = select(2, ...)
local CreateFrame             = CreateFrame
local SetOverrideBindingClick = SetOverrideBindingClick
local ClearOverrideBindings   = ClearOverrideBindings
local assert                  = assert
local pairs                   = pairs
local next                    = next
local type                    = type
local NeP                     = NeP

CK.Version                    = 0.11

local KeyboardKeyDown, KeybindGroups = {}, {}

local function KeyboardCallback(key, down, button)
	if down then
		KeyboardKeyDown[key] = true
	else
		KeyboardKeyDown[key] = nil
	end
  for _, v in pairs(button.callback) do
    v(key, down)
  end
end

NeP.DSL:Register("customkeybind", function(_, key)
	key = key:upper():gsub(" ", "-")
	return KeyboardKeyDown[key] or false
end)

local function noop() end

local function checktype(item, correcttype)
  assert(type(item) == correcttype, "Invalid type. Expected: "..correcttype)
end

CK.CreatedKeybinds = {}

function CK:Add(group, key, callback)
  checktype(group, "string")
  checktype(key, "string")
  if callback then checktype(callback, "function") end
  key = key:upper()
  self.CreatedKeybinds[key] = self.CreatedKeybinds[key] or
			CreateFrame("BUTTON", "NePCustomKeybind"..key)
  self.CreatedKeybinds[key].callback = self.CreatedKeybinds[key].callback or {}
  self.CreatedKeybinds[key].callback[group] = callback or noop
	SetOverrideBindingClick(self.CreatedKeybinds[key], true, key, self.CreatedKeybinds[key]:GetName())
	self.CreatedKeybinds[key]:SetScript("OnClick", function(button, _, down)
		KeyboardCallback(key, down, button)
	end)
	self.CreatedKeybinds[key]:RegisterForClicks("AnyUp", "AnyDown")
  KeybindGroups[group] = KeybindGroups[group] or {}
  KeybindGroups[group][key] = self.CreatedKeybinds[key]
end

function CK:Remove(group, key)
  checktype(group, "string")
  checktype(key, "string")
  key = key:upper()
  if not self.CreatedKeybinds[key] or not KeybindGroups[group] or
			not KeybindGroups[group][key] then
		return
	end
  self.CreatedKeybinds[key].callback[group] = nil
  KeybindGroups[group][key] = nil
  if next(self.CreatedKeybinds[key].callback) == nil then
    ClearOverrideBindings(self.CreatedKeybinds[key])
  end
end

function CK:RemoveAll(group)
  checktype(group, "string")
  if not KeybindGroups[group] then return end
  for key in pairs(KeybindGroups[group]) do
    self:Remove(group, key)
  end
  KeybindGroups[group] = nil
end

NeP.CustomKeybind = CK
