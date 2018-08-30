// Edsger Dijkstra Mathématicien hollandais 1930-2002
// "Diviser pour reigner", "Divide and Conquer"


unit Dijkstracls;

interface
 uses Maptree,sysUtils;
const

 DKAMAXCOL=19;
 DKAMAXLINE=19;
 DKAHURDLE=1; // Obstacle in the matrix
 DKANONE=0;

type
 TDkaMatrix=array [1..DKAMAXCOL] of array [1..DKAMAXLINE] of integer;

 TDijkstra=class
  protected
  FClosednodes : TMapList;
  FSolutionsTree : TMapTree;
  fMap : TDkaMatrix;
  fStartNode : TMapTreeNode;
  fStopNode:TMapTreeNode;
  procedure ClosedNodesListInitialisation;
  function RecurNextNodes(parent:TMapTreeNode):boolean;
  function IsLastNode(px,py:integer):boolean;
  procedure RecurgetWay(node:TMapTreeNode;var list:TMapList);
  public
  procedure SearchWay(sx,sy,ex,ey:integer);
  procedure GetWayNodes(var list:TMapList);
  constructor create(map:TDkaMatrix);
  destructor destroy;override;
 end;
implementation

{ TDijkstra }

procedure TDijkstra.ClosedNodesListInitialisation;
var i,j:integer; closednode:TMapTreeNode;
begin
 for i:=1 to DKAMAXLINE do
  for j:=1 to DKAMAXCOL do begin
   if fMap[j][i]=DKAHURDLE then
   begin
    ClosedNode:=TMapTreeNode(fClosedNodes.Add);
    ClosedNode.x:=j;
    ClosedNode.y:=i;
   end;
  end;
end;

constructor TDijkstra.create(map: TDkaMatrix);
begin
 fMap:=map;
// Internal creation
 FClosedNodes:=TMapList.create;
 FSolutionsTree:=TMapTree.create;
// Retrieve the closed node from the map.
 ClosedNodesListInitialisation;
end;

destructor TDijkstra.destroy;
begin
 FClosedNodes.free;
 FSolutionsTree.free;
end;

procedure TDijkstra.GetWayNodes(var list: TMapList);
begin
 if fSolutionsTree.froots.count>0 then
 begin
  list.Add(TMapTreeNode(fSolutionsTree.fRoots.list[0]));
  RecurGetWay(TMapTreeNode(fSolutionsTree.fRoots.list[0]),list);
 end;
end;

function TDijkstra.IsLastNode(px,py:integer):boolean;
begin
 if (px=fStopNode.x) and (py=fStopNode.y) then
  result:=true
 else
  result:=false;

end;
procedure TDijkstra.RecurGetWay(node: TMapTreeNode;
  var list: TMapList);
begin
 if node.fsuccessors.count>0 then
 begin
  list.Add(TMapTreeNode(Node.Fsuccessors.list[0]));
  RecurGetWay(TMapTreeNode(Node.Fsuccessors.list[0]),list);
 end;
end;

function TDijkstra.RecurNextNodes(parent:TMapTreeNode):boolean;
var newNode,TreeNodeToDel:TMapTreeNode;x,y:integer;//lastNode:TMapTreeNode;
begin

 result:=false;

 x:=parent.x;
 y:=parent.y;

 If isLastNode(x,y) then
 begin
  result:=true;
  exit;
 end;

 // test xpos+1

 if x+1<=DKAMAXCOL then begin
   newnode:=TMapTreeNode.create(parent,x+1,y,fStopNode);
   if not FClosedNodes.isItemInTheList(newnode) then
    if FSolutionsTree.FindNode(newnode)=nil then
     parent.addsuccessor(newnode);
 end;

 // test ypos+1

 if y+1<=DKAMAXLINE then begin
   newnode:=TMapTreeNode.create(parent,x,y+1,fStopNode);
   if not FClosedNodes.isItemInTheList(newnode) then
    if FSolutionsTree.FindNode(newnode)=nil then
     parent.addsuccessor(newnode);
 end;

 // test xpos-1

 if x-1>0 then begin
   newnode:=TMapTreeNode.create(parent,x-1,y,fStopNode);
   if not FClosedNodes.isItemInTheList(newnode) then
    if FSolutionsTree.FindNode(newnode)=nil then
     parent.addsuccessor(newnode);
 end;

 // test ypos-1

 if y-1>0 then begin
   newnode:=TMapTreeNode.create(parent,x,y-1,fStopNode);
   if not FClosedNodes.isItemInTheList(newnode) then
    if FSolutionsTree.FindNode(newnode)=nil then
     parent.addsuccessor(newnode);
 end;

 // checks and exit

 if parent.fsuccessors.count=0 then
 begin
  TreeNodeToDel:=parent;
  parent:=TMapTreeNode(parent.FPredecessor);
  if parent=nil then
   raise Exception.create('Target unreachable, no path calculable !!!');
  FClosedNodes.add(TreeNodeToDel);
  parent.DeleteAllSuccessor;
  result:=RecurNextNodes(parent);
 end else
 begin
  TMapList(parent.fsuccessors).SortByHeuristic;
  if not result then
   result:=RecurNextNodes(TMapTreeNode(parent.fsuccessors.list[0]));
 end;
end;

procedure TDijkstra.SearchWay(sx, sy, ex, ey: integer);
begin
 // initialisation
 fStartNode:=TMapTreeNode.Create;
 fStartNode.x:=sx;
 fStartNode.y:=sy;

 fStopNode:=TMapTreeNode.Create;
 fStopNode.x:=ex;
 fStopNode.y:=ey;

 if FClosedNodes.isItemInTheList(fStartNode) then
 begin
  raise Exception.Create('The Initial node is an Obstacle');
 end;
 if FClosedNodes.isItemInthelist(fStopNode) then
 begin
  raise Exception.create('The Target node is an Obstacle');
 end;
 fSolutionsTree.AddRefRoot(fStartNode);
 if RecurNextNodes(fStartNode) then
 begin
  // find the way
 end else
  // don't find the way
 // first test
end;

end.
