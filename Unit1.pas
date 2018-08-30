unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,DijkstraCls,MapTree,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    imgMain: TImage;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    fMap:TDkaMatrix ;
    fStartX,fStartY,FEndX,FEndy:integer;
    FMode:Integer;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var Dijkstra:TDijkstra;nodes:TMapList;i:integer;sMessage:string;
    oldc:TColor;rc:TRect;
begin

 DijkStra:=TDijkstra.create(fmap);
 try
  nodes:=TMapList.create;

  DijkStra.SearchWay(fStartX,fStartY,FEndX,FEndY);
  showmessage('Path found');

  Dijkstra.GetWayNodes(nodes);

  for i:=0 to nodes.count-1 do begin
   if i=0 then
    sMessage:='('+inttostr(TMapTreeNode(nodes.List[i]).x)+','+inttostr(TMapTreeNode(nodes.list[i]).y)+')'
   else
    sMessage:=sMessage+'; ('+inttostr(TMapTreeNode(nodes.List[i]).x)+','+inttostr(TMapTreeNode(nodes.list[i]).y)+')';
  end;
  showmessage(sMessage);

  for i:=0 to nodes.count -1 do
  begin
   rc.left:=(TMapTreeNode(nodes.list[i]).x-1)*16;
   rc.top:=(TMapTreeNode(nodes.list[i]).y-1)*16;
   rc.bottom:=rc.top+16;
   rc.right:=rc.left+16;
   oldc:=ImgMain.Canvas.Brush.Color;
   ImgMain.Canvas.Brush.Color:=$00ff00;
   ImgMain.Canvas.FillRect(rc);
   ImgMain.Canvas.brush.color:=oldc;
  end;
 except
  on e:Exception  do showmessage(e.message);
 end;

 DijkStra.free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var x,y:integer;
begin
 for x:=0 to DKAMAXCOL-1 do
 begin
  imgMain.Canvas.MoveTo(x*16,0);
  imgMain.Canvas.LineTo(x*16,(DKAMAXLINE-1)*16);
 end;
 for y:=0 to DKAMAXLINE-1 do
 begin
  imgMain.Canvas.MoveTo(0,y*16);
  imgMain.Canvas.lineTo((DKAMAXCOL-1)*16,y*16);
 end;
end;



procedure TForm1.imgMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var rc:TRect;  oldc:TColor;
begin
 rc.left:=(X div 16)*16;
 rc.top:=(Y div 16)*16;;
 rc.right:=rc.left+16;
 rc.Bottom:=rc.top+16;
 if FMode=0 then
 begin
  if FMap[(rc.left div 16)+1][(rc.Top div 16)+1]=DKANONE then
  begin
  FMap[(rc.left div 16)+1][(rc.Top div 16)+1]:=DKAHURDLE;
  oldc:=ImgMain.Canvas.Brush.Color;
  ImgMain.canvas.brush.color:=0;
  ImgMain.Canvas.FillRect( rc);
  ImgMain.canvas.brush.color:=oldc;
  end else
  begin
   FMap[(rc.left div 16)+1][(rc.Top div 16)+1]:=DKANONE;
   ImgMain.Canvas.FillRect( rc);
   inc(rc.right);
   inc(rc.bottom);
   ImgMain.Canvas.Rectangle(rc);
  end;
 end else
  if FMode=1 then begin
   fStartX:=(rc.left div 16)+1;
   fStartY:=(rc.top div 16)+1;
  end else
   if FMode=2 then begin
    fEndX:=(rc.left div 16)+1;
    fEndY:=(rc.top div 16)+1;
   end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 Fmode:=0;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Fmode:=1;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 FMode:=2;
end;

end.
