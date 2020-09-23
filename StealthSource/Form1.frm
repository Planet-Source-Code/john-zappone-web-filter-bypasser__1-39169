VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Stealth Project Server"
   ClientHeight    =   2340
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2340
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSWinsockLib.Winsock Winsock2 
      Index           =   0
      Left            =   4200
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   4080
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock winServer 
      Left            =   3960
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin InetCtlsObjects.Inet Inet1 
      Index           =   0
      Left            =   3840
      Top             =   0
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin VB.ListBox List2 
      Height          =   1425
      Left            =   2040
      TabIndex        =   5
      Top             =   840
      Width           =   2535
   End
   Begin VB.ListBox List1 
      Height          =   1425
      Left            =   120
      TabIndex        =   2
      Top             =   840
      Width           =   1815
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Stop"
      Height          =   375
      Left            =   960
      TabIndex        =   1
      Top             =   120
      Width           =   735
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Start"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   735
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   0
      Left            =   3480
      TabIndex        =   6
      Top             =   0
      Visible         =   0   'False
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "History"
      Height          =   255
      Left            =   2040
      TabIndex        =   4
      Top             =   600
      Width           =   2535
   End
   Begin VB.Label Label1 
      Caption         =   "IP Addresses"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   600
      Width           =   1815
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Winsock1.Close ' closes any current connections
Winsock1.LocalPort = "81" ' hosting port you can change this
Winsock1.Listen
End Sub

Private Sub Command2_Click()
winServer.Close
End Sub
'Programmer John Zappone aka Digital
'This program gets by any school filters i tested it at my
'school and it has gotten into many sites that where blocked.
'to use this just run and hit start it will host a server on
'you computer and to access sites use your url this is an ex.
'http://127.0.0.1:81/url=http://www.nintendo.com
':81 is your port which is delcared below
'there is some problems with this program its not 100% working
'the reason is that it doesnt see the server after you send the
'first page its hard to explain but i know the reason.
'
'How does this thing work and whatnot
'ok its simple all it does is sends the page to your computer
'and then your computer will send it to the person wanted to see
'the filter site, so you are being the server of the page they want to
'see.  WARNING this uses alot of your bandwidth so make sure you use
'a broadband modem or anything higher.
'please send suggestions to me at digitalfx2k2@hotmail.com
' and if you can fix my little problem then plz send it to me thanks


Private Sub Form_Load()
For i = 1 To 200
Load Winsock2(i) 'loads 200 winsock controls means 200 people allowed.
Load Inet1(i)       ' loads 200 inet controls this gets data from the site you want
Next i
End Sub

Private Sub winServer_ConnectionRequest(ByVal requestID As Long)
If winServer.State <> sckConnected Then 'your main winsock that redirects the connections
winServer.Close ' closes after connection adapted
End If
Call winServer.Accept(requestID)
End Sub

Private Sub winServer_DataArrival(ByVal bytesTotal As Long)
Dim message As String
Call winServer.GetData(message) 'gets input from user
End Sub

Private Sub Winsock1_ConnectionRequest(ByVal requestID As Long)
Dim i As Integer
For i = 0 To 200
    If Winsock2(i).State = sckClosed Then 'checks to see if its close
        Winsock2(i).Close ' closes it officially
        Winsock2(i).Accept (requestID) ' then accepts connection
        Exit Sub
    End If
Next i
End Sub

Private Sub Winsock2_DataArrival(Index As Integer, ByVal bytesTotal As Long)
On Error Resume Next    ' this is the main part where everything happens
Dim strData As String, strPage As String
Winsock2(Index).GetData strData ' gets the page people want
List2.AddItem (strData) ' adds the header code
List1.AddItem (Winsock2(Index).RemoteHostIP) ' gets there ip address for logging
b = InStr(1, strData, " HTTP") ' gets to see if its a webpage
a = InStr(1, strData, "url=") ' this is our special code
c = InStr(1, strData, "GET /url=") 'make sure its calling this program
If a <> 0 And b <> 0 = True Then ' checks to se if http and url= is found in the request
    strPage = Mid(strData, a + 4, b - a - 4) 'gets the site they want to see
    mainUrl = strPage ' assigns to temp declare
    DoEvents ' tells the controls to finish their jobs
        strPageData = Inet1(Index).OpenURL(strPage) ' retrives data from the site they want and assigns it
        ' this following part is an addition it will write data to the top of the page for the viewer to change sites wihtout having to type in the long url.
        strTools = "<script>function dfxnav(){ var NewSite; NewSite=""http://digitalfx.dns2go.com:81/url="" + document.dfxnav.webpagedfx.value;location.href = NewSite;}</script><center><form name='dfxnav' action='javascript:dfxnav();' method='post'><table width='300'cellspacing='0' cellpadding='0'><tr><td height='26' background='http://digitalfx.dns2go.com/studios/asp/stealth/stealth.gif'>&nbsp;</td></tr><tr><td bgcolor='002946'><input type='text' value='http://' name='webpagedfx' size='40' style='background:white;border:1px solid #000000; font-size: 8pt; font-family: Verdana; color: #048AFB'><input type='submit' value='Go'  style='background:white;border:1px solid #000000; font-size: 8pt; font-family: Verdana; color: #048AFB'></td></tr></table></form></center>" & strPageData
    DoEvents
    Winsock2(Index).SendData strPageData ' sends back the page
    'this is just the addition code you can activate it and it iwll send the code and edit the top part of the page with this
    'Winsock2(Index).SendData strTools
End If
End Sub

Private Sub Winsock2_SendComplete(Index As Integer)
If Inet1(Index).StillExecuting = True = True Then ' checks to see if the page is done loading
Else
Winsock2(Index).Close ' if the page is done loading it will close the users connection.
End If
End Sub

