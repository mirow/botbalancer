#pragma semicolon 1

#include <sourcemod>
#include <tf2_stocks>

#define TF_TEAM_BLU					3
#define TF_TEAM_RED					2

new Handle:g_hEnabled = INVALID_HANDLE;
new Handle:g_tf_bot_quota = INVALID_HANDLE;

public Plugin:myinfo =
{
	name        = "TF2 Bot Balancer",
	author      = "Max Power",
	description = "Always have zero or one bots in game, to make teams even.",
	version     = "0.2",
	url         = "http://www.w3.fi"
}

public OnPluginStart()
{
	g_hEnabled = CreateConVar("sm_bot_balancer", "1",  "Enable/disable bot balancer in TF2.");
	g_tf_bot_quota = FindConVar("tf_bot_quota");
}

public OnClientPutInServer(client)
{
	if(g_hEnabled && !IsFakeClient(client)) {
		// not a bot
		new tf_bot_quota = GetConVarInt(g_tf_bot_quota);
		if (getPlayerCount()>tf_bot_quota) {
			// uneven count, change bot limit
			PrintToChatAll( "W3Bots: Player count is %d, upping bot quota to %d.", getPlayerCount(), tf_bot_quota+2);  
			SetConVarInt(g_tf_bot_quota, tf_bot_quota+2);
		} else {
			PrintToChatAll( "W3Bots: Player count is %d, NOT changing bot quota.", getPlayerCount());  
		}
	}	
}

public OnClientDisconnect(client)
{
	if(g_hEnabled && !IsFakeClient(client)) {
		// not a bot
		new tf_bot_quota = GetConVarInt(g_tf_bot_quota);
		if (getPlayerCount()<=tf_bot_quota-1) {
			// two extra bots, remove them
			PrintToChatAll( "W3Bots: Player count is %d, reducing bot quota to %d.", getPlayerCount(), tf_bot_quota-2);  
			SetConVarInt(g_tf_bot_quota, tf_bot_quota-2);
		} else {
			PrintToChatAll( "W3Bots: Player count is %d, NOT changing bot quota.", getPlayerCount());  
		}
	}	
}

getPlayerCount()
{
	new clientcount = 0;
	for(new i=1;i<=MaxClients;i++) {
		if (IsClientInGame(i) && !IsFakeClient(i)) {
			clientcount++;
		}
	}
	return clientcount;
}
