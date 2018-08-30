unit MapTree;

interface
uses GenericTree,math;

type


 TMapTreeNode=class;

 TMapList=class(TGenericList)
  public
  function isItemInTheList(it:TMapTreeNode):boolean;
  procedure SortByHeuristic;
  procedure Swap(var a, b:TMapTreeNode);
  function Add:TGenericItemList;override;
 end;
 TMapTreeNode=class(TGenericTreeNode)
  protected
  fx,fy:integer;
  fh:extended;
  public
  constructor create;overload;override;
  constructor create(parent:TMapTreeNode;x,y:integer;stopnode:TMapTreeNode);reintroduce;overload;
  procedure SetHeuristicTo(TargetNode:TMapTreeNode);
  procedure Clone(v:TGenericItemList);override;

  property x : integer read fx write fx;
  property y : integer read fy write fy;
  property heuristic : extended read fh;
 end;
 TMapTree=class(TGenericTree)
  public
  function FindNode(node: TMapTreeNode): TMapTreeNode;
  function GetNextNode(node1,
  expNode: TMapTreeNode): TMapTreeNode;

 end;
implementation


{ TMapList }

function TMapList.Add: TGenericItemList;
begin
   result:=TMapTreeNode.create;
   AddRef(result);

end;


function TMapList.isItemInTheList(it: TMapTreeNode): boolean;
var i:integer;
begin
 result:=false;
 for i:=0 to count -1 do
  if (it.fx=TMapTreeNode(list[i]).fx) and (it.fy=TMapTreeNode(list[i]).fy) then
  begin
   result:=true;
   break;
  end;
end;

procedure TMapList.SortByHeuristic;
var i,j:integer; a,b:TMapTreeNode;
begin
 for i:=0 to Count -2 do
 begin
  for j:=1 to Count -1 do begin
   a:=TMapTreeNode(List[j]);
   b:=TMapTreeNode(List[i]);
   if a.heuristic<b.heuristic then
    Swap(a,b);
  end;
 end;
end;

procedure TMapList.Swap(var a,  b: TMapTreeNode);
var c:TMapTreeNode;
begin
 c:=TMapTreeNode.create;
 c.clone(a);
 a.clone(b);
 b.clone(c);
 c.free;
end;

{ TMapTreeNode }

constructor TMapTreeNode.create;
begin
  inherited;

end;

procedure TMapTreeNode.Clone(v: TGenericItemList);
begin
  inherited;
  fx:=TMapTreeNode(v).x;
  fy:=TMapTreeNode(v).y;
  fh:=TMapTreeNode(v).heuristic;
end;

constructor TMapTreeNode.create(parent:TMapTreeNode;x,y:integer;stopnode:TMapTreeNode);
begin
 create;
 fx:=x;
 fy:=y;
 SetHeuristicTo(stopnode);
 fpredecessor:=parent;
end;

procedure TMapTreeNode.SetHeuristicTo(TargetNode: TMapTreeNode);
begin
 fh:=power( (x-TargetNode.x),2)+power( (y-TargetNode.y),2);
end;

function TMapTree.FindNode(node: TMapTreeNode): TMapTreeNode;
var i:integer;
begin
  result:=nil;
  for i:=0 to froots.count-1 do begin
   if (TMapTreeNode(froots.list[i]).x=node.x) and (TMapTreeNode(froots.list[i]).y=node.y) then result:=TMapTreeNode(froots.list[i]) else
    result:=getnextnode(TMapTreeNode(froots.list[i]),node)
  end;

end;

function TMapTree.GetNextNode(node1,
  expNode: TMapTreeNode): TMapTreeNode;
var i:integer;
begin
  result:=nil;
  if node1<>nil then begin
   for i:=0 to node1.fsuccessors.count -1 do
   begin
    if node1.fsuccessors.list[i]<>nil then
     if (TMapTreeNode(node1.fsuccessors.list[i]).x=expnode.x) and (TMapTreeNode(node1.fsuccessors.list[i]).y=expnode.y)  then
     begin
      result:=TMapTreeNode(node1.fsuccessors.list[i]);
      break;
     end else
      if result=nil then
       result:=GetNextNode(TMapTreeNode(node1.fsuccessors.list[i]),expnode);
   end;
  end;
end;


end.
