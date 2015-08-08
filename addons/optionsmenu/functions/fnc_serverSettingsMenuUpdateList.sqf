/*
 * Author: Glowbal
 * Updates the setting when the client has selected a new value.  Saves to profilenamespace.
 *
 * Arguments:
 * 0: Update the keylist as well <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [false] call ACE_optionsmenu_fnc_settingsMenuUpdateList
 *
 * Public: No
 */

#include "script_component.hpp"

private ["_settingsMenu", "_ctrlList", "_settingsText", "_color", "_settingsColor", "_updateKeyView", "_settingsValue", "_selectedCategory"];
DEFAULT_PARAM(0,_updateKeyView,true);

disableSerialization;
_settingsMenu = uiNamespace getVariable 'ACE_serverSettingsMenu';
_ctrlList = _settingsMenu displayCtrl 200;

lbclear _ctrlList;

_selectedCategory = GVAR(categories) select GVAR(currentCategorySelection);

systemChat format["_selectedCategory: %1", _selectedCategory];


switch (GVAR(optionMenu_openTab)) do {
    case (MENU_TAB_SERVER_OPTIONS): {
        {
            if (_selectedCategory == "" || _selectedCategory == (_X select 8)) then {
                if ((_x select 3) != "") then {
                    _ctrlList lbadd (_x select 3);
                } else {
                    _ctrlList lbadd (_x select 0);
                };

                _settingsValue = _x select 9;

                // Created disable/enable options for bools
                _settingsText = if ((_x select 1) == "BOOL") then {
                    [(localize ELSTRING(common,No)), (localize ELSTRING(common,Yes))] select _settingsValue;
                } else {
                    (_x select 5) select _settingsValue;
                };

                _ctrlList lbadd (_settingsText);
            };
        }foreach GVAR(serverSideOptions);
    };
    case (MENU_TAB_SERVER_COLORS): {
        {
            if (_selectedCategory == "" || _selectedCategory == (_X select 8)) then {
                _color = +(_x select 9);
                {
                    _color set [_forEachIndex, ((round (_x * 100))/100)];
                } forEach _color;
                _settingsColor = str _color;
                if ((_x select 3) != "") then {
                    _ctrlList lbadd (_x select 3);
                } else {
                    _ctrlList lbadd (_x select 0);
                };
                _ctrlList lbadd (_settingsColor);
                _ctrlList lnbSetColor [[_forEachIndex, 1], (_x select 9)];
            };
        }foreach GVAR(serverSideColors);
    };
    case (MENU_TAB_SERVER_VALUES): {
        {
            if (_selectedCategory == "" || _selectedCategory == (_X select 8)) then {
                if ((_x select 3) != "") then {
                    _ctrlList lbadd (_x select 3);
                } else {
                    _ctrlList lbadd (_x select 0);
                };
                _settingsValue = _x select 9;
                if (typeName _settingsValue != "STRINg") then {
                    _settingsValue = format["%1", _settingsValue];
                };
                _ctrlList lbadd (_settingsValue);
            };
        }foreach GVAR(serverSideValues);
    };
};
if (_updateKeyView) then {
    [] call FUNC(serverSettingsMenuUpdateKeyView);
};
