/*
    Client-side Script
    
    Here you can find more script examples: http://forum.vc-mp.org/
    Access the forum, and go to Client Scripting.
    Wish you the best !

    VC:MP Client Documentation: http://wiki.vc-mp.org/wiki/Client-side_Scripting_Resources
*/

sX <- GUI.GetScreenSize().X;
sY <- GUI.GetScreenSize().Y;

local   SRV_NAME;

local   sprite_logo,
        label_name;
        
        
// as I said, it must be the same in both sides.
enum StreamType
{
    ServerName = 0x01
}
   
//-------------------------------------------------------------------
    
function Script::ScriptLoad()
{
    Console.Print( "[#AAAAAA]*> Client-side script was loaded. <*" );
    SendDataToServer( StreamType.ServerName ); // we ask server for it's name, to display on screen
    Console.Print( "Client is asking for server's name" );

    // creating sprite
    sprite_logo = GUISprite( "logo.png", VectorScreen( sX-(sX/5), sY-(sY/5) ) );
    sprite_logo.Size = VectorScreen( sX / 6, sY / 6 );
    sprite_logo.Alpha = 200;
}

function Script::ScriptProcess()
{
}

function Player::PlayerShoot( player, weapon, hitEntity, hitPosition )
{
}

function Server::ServerData( stream )
{
    // here you receive the data you send from server
    local type = stream.ReadByte();
    switch( type )
    {
        case StreamType.ServerName:
        {
            Console.Print( "Client received server's name, so it's ready to display it." );
            // client received server's name, so we can create the label
            SRV_NAME = stream.ReadString();
            
            label_name = GUILabel( );
            label_name.Pos = VectorScreen( sX/25, sY-(sY/14) );
            label_name.FontSize = 20;
            label_name.TextColour = Colour( 255, 255, 255 );
            label_name.FontFlags = ( GUI_FFLAG_BOLD || GUI_FLAG_INHERIT_ALPHA   );
            label_name.Text = SRV_NAME;
        }
        break;
        
        default:
        break;
    }
}

function onGameResize( width, height )
{
}

function GUI::GameResize( width, height )
{
}

function GUI::ElementClick( element, mouseX, mouseY )
{
}

function GUI::ElementRelease( element, mouseX, mouseY )
{
}

function GUI::ElementBlur( element )
{
}

function GUI::CheckboxToggle( checkbox, checked )
{
}

function GUI::InputReturn( editbox )
{
}

//-------------------------------------------------------------------

function SendDataToServer( ... )
{
    if( vargv[0] )
    {
        local   byte = vargv[0],
                len = vargv.len();
                
        if( 1 > len ) Console.Print( "ToClent <" + byte + "> No params specified." );
        else
        {
            local pftStream = Stream();
            pftStream.WriteByte( byte );

            for( local i = 1; i < len; i++ )
            {
                switch( typeof( vargv[i] ) )
                {
                    case "integer": pftStream.WriteInt( vargv[i] ); break;
                    case "string": pftStream.WriteString( vargv[i] ); break;
                    case "float": pftStream.WriteFloat( vargv[i] ); break;
                }
            }
            
            Server.SendData( pftStream );
        }
    }
    else Console.Print( "ToClient: Not even the byte was specified..." );
}