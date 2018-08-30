unit GenericTree;

interface

 const TREENODE_DELETEALL :integer=1;
type
// TCNodeAction=(naNoAction,naSetStartDate);

 TGenericItemList=class
  public
  procedure clone(v:TGenericItemList);virtual;
  constructor create;virtual;
 end;

 TGenericList=class
  private
   fcount : integer;
  protected
   function getList(i:integer):TgenericItemList;virtual;
  public
   fList : array of TGenericItemList;

   constructor create;virtual;
   function Add: TGenericItemList;overload;virtual;
   function Add(item: TGenericItemList): TGenericItemList;overload;
   function AddRef(item:TGenericItemList):TGenericItemList;
   function Delete(index:integer):boolean;overload;
   function Delete(item:TGenericItemList):boolean;overload;
   procedure clear;
   property Count:integer read fcount;
   property List[ind:integer]:TgenericItemList read getList;
   destructor destroy;override;
 end;

 TGenericTreeNode=class(TGenericItemList)
  public
  fpredecessor : TGenericTreeNode;
  fsuccessors : TGenericList;//: array of TGenericTreeNode;
  id_node:integer;
  function addsuccessor(successor:TGenericTreeNode):boolean;
  function deletesuccessor(node:TGenericTreeNode):boolean;
  procedure DeleteAllSuccessor;

  constructor create;override;
  //constructor create(data:tobject); overload; virtual;
  function delete(mode:integer):boolean; virtual;
  destructor destroy; override;

 end;

 TGenericTree=class
  public
  froots :TGenericList; //array of TGenericTreeNode;
  fmaxid_node:integer;
  function InsertNodeAfter(id_node:integer):TGenericTreeNode; overload;virtual;
  function InsertNodeBefore(id_node:integer):TGenericTreeNode;virtual;
  procedure InsertNodeAfter(parentnode,node:TGenericTreeNode);overload;virtual;
  function FindNode(node:integer):TGenericTreeNode;overload;
  function GetNextNode(node1:TGenericTreeNode;const expnode:integer):TGenericTreeNode;overload;
  function CreateNewNode(targetnode:TGenericTreeNode):TGenericTreeNode;virtual;
  //function AddRoot(data:tobject):TGenericTreeNode;
  function AddRefRoot(data:TGenericTreeNode):TGenericTreeNode;
//  procedure DeleteRoot(data:tobject);

  //function DeleteRoot(id_node:integer):boolean;
  function GetRoot(id_node:integer):TGenericTreeNode;
  function DemoteRoot(node,predecessor:TGenericTreeNode):boolean;
  function PromoteRoot(node:TGenericTreeNode):boolean;
  constructor Create;virtual;
 // constructor create(data:tobject);overload;
  destructor destroy;override;
  procedure NextToDelete(node:TGenericTreeNode);
  function DeleteNode(id_node,mode:integer):boolean;overload;
  function DeleteNode(todeletenode:TGenericTreeNode;mode:integer):boolean;overload;
  function DeleteRoot(node:TGenericTreeNode;mode:integer):boolean;
  function AttachNodeTo(sourcenode,targetnode:TGenericTreeNode):boolean;overload;
  function AttachNodeTo(sourcenode_id:integer;targetnode:TGenericTreeNode):boolean;overload;
  function AttachnodeTo(sourcenode_id,targetnode_id:integer):boolean;  overload;
  function deleteNode(node:TGenericTreeNode):boolean;overload;virtual;


//function DeleteNode(node:^TGenericTreeNode):boolean;

 end;
implementation

{$T+}
constructor TGenericTreeNode.create;
begin
 fsuccessors:=TGenericList.create;
 fpredecessor:=nil;
end;
function TGenericTreeNode.addsuccessor(successor:TGenericTreeNode):boolean;
begin
 try
    fsuccessors.addref(successor);
  result:=true;
 except
  result:=false;
 end;
end;
function TGenericTree.InsertNodeAfter(id_node:integer):TGenericTreeNode;
var targetnode:TGenericTreeNode;
begin
 if id_node>0 then begin
  targetnode:=FindNode(id_node);
  if (targetnode=nil) then
   result:=nil
  else begin
    // cree un nouveau node
    Result:=CreateNewNode(targetnode);
  end;
 end else result:=nil;
end;
procedure TGenericTree.InsertNodeAfter(parentnode,node:TGenericTreeNode);
var  i:integer;
begin
 // calculer le next node
// Testter parentnode=nil
 if parentnode=nil then begin
  node.fpredecessor:=nil;
  if froots.count=0 then  begin
   PromoteRoot(node);

  // aucun process dans l'arbre
  // on ne fait rien car pas de successor
  end else  begin // il y a des process après
   // déterminer le successor c'est une root
    PromoteRoot(node);
    DemoteRoot(TGenericTreeNode(froots.list[0]),node); // normalement
  end;
 end else
 begin // le parent existe
  if parentnode.fsuccessors.count=0 then begin // c'est une feuille
   AttachNodeTo(node,parentnode);
  end else begin// c'est une branche
   for i:=0 to parentnode.fsuccessors.count -1 do
    node.addsuccessor(TGenericTreeNode(parentnode.fsuccessors.list[i]));
   parentnode.deleteallsuccessor;
   parentnode.addsuccessor(node);
   node.fpredecessor:=parentnode;
  end;
 end;

end;

constructor TGenericTree.create;
begin
 froots:=TGenericList.create;
end;

function TGenericTree.InsertNodeBefore(id_node:integer):TGenericTreeNode;
var targetnode:TGenericTreeNode;
begin
 if id_node>0 then begin
  targetnode:=findnode(id_node);
  if (targetnode<>nil) then begin
   if targetnode.fpredecessor<>nil then begin
     targetnode:=targetnode.fpredecessor;
     Result:=CreateNewNode(targetnode)
   end else
   result:=nil;
  end else
   result:=nil;
  end else result:=nil;
end;
function TGenericTree.FindNode(node:integer):TGenericTreeNode;
var i:integer; res:TGenericTreeNode;
begin
  res:=nil;
  for i:=0 to froots.count-1 do begin
   if TGenericTreeNode(froots.list[i]).id_node=node then res:=TGenericTreeNode(froots.list[i]) else
    res:=getnextnode(TGenericTreeNode(froots.list[i]),node)
  end;
  result:=res;
end;

function TGenericTree.GetRoot(id_node:integer):TGenericTreeNode;
var i:integer; res:TGenericTreeNode;
begin
 res:=nil;
 for i:=0 to froots.count -1 do
  if TGenericTreeNode(froots.list[i]).id_node=id_node then res:=TGenericTreeNode(froots.list[i]);

 result:=res;
end;

function TGenericTree.CreateNewNode(targetnode:TGenericTreeNode):TGenericTreeNode;
var newnode: TGenericTreeNode;
begin
   try
    newnode:=TGenericTreeNode.create;
    newnode.fpredecessor:=targetnode;
    targetnode.addsuccessor(newnode);
    result:=newnode;
   except
    result:=nil;
   end;

end;

function TGenericTree.GetNextNode(node1:TGenericTreeNode;const expnode:integer):TGenericTreeNode;
var i:integer;  res:TGenericTreeNode;
begin
 res:=nil;
 for i:=0 to node1.fsuccessors.count -1 do
 begin
  if node1.fsuccessors.list[i]<>nil then
   if TGenericTreeNode(node1.fsuccessors.list[i]).id_node=expnode then
   begin
    res:=TGenericTreeNode(node1.fsuccessors.list[i]);
    break;
   end else
     res:=GetNextNode(TGenericTreeNode(node1.fsuccessors.list[i]),expnode);
 end;

 result:=res;
end;
function TGenericTree.DemoteRoot(node,predecessor:TGenericTreeNode):boolean;
var i:integer;
begin
  try
   node.fpredecessor:=predecessor;
   predecessor.addsuccessor(node);
      // enlever le node de la list des racines

   for i:=0 to froots.count -1 do
    if TGenericTreeNode(froots.list[i]).id_node=node.id_node then
    begin
     //ind:=i;
     froots.delete(i);
     break;
    end;

   result:=true;
  except
   result:=false;
  end;

end;
function TGenericTree.PromoteRoot(node:TGenericTreeNode):boolean;
var prevnode:TGenericTreeNode;
begin
 try
  prevnode:=node.fpredecessor;
  if prevnode<>nil then
   prevnode.deletesuccessor(node);
  node.fpredecessor:=nil;
  // ajoute à la racine
  froots.addref(node);
  result:=true;
 except
  result:=false;
 end;
end;
function TGenericTreeNode.deletesuccessor(node:TGenericTreeNode):boolean;

begin
   result:=fsuccessors.delete(node);
end;
destructor TGenericTreeNode.destroy;
begin
 // data.free;
 //fdata.Free;
 fpredecessor:=nil;
 fsuccessors.free;
end;
destructor TGenericTree.destroy;
var i:integer;
begin
// Destruction recursive de l'arbre en partant des racines vers les extremes
 for i:=0 to froots.count-1 do
 begin
  NextToDelete(TGenericTreeNode(froots.list[i]));
  //froots[i].free;
 end;
 froots.Free;
end;
procedure TGenericTree.NextToDelete(node:TGenericTreeNode);
var i:integer;
begin
 if node.fsuccessors.count>0 then
  for i:=0 to node.fsuccessors.count-1 do
   NextToDelete(TGenericTreeNode(node.fsuccessors.list[i]));
 node.free;
end;

function TGenericTreeNode.Delete(mode:integer):boolean;
begin
 try
//  if mode=TREENODE_DELETEALL then
//   self.fData.Free;
  Free;
  result:=true;
 except
  result:=false;
 end;
end;
function TGenericTree.DeleteNode(id_node,mode:integer):boolean;
var todeletenode:TGenericTreeNode;
begin
 result:=true;
 toDeleteNode:=FindNode(id_node);
 if toDeleteNode<>nil then
 DeleteNode(todeleteNode,mode) else result:=false;
end;
function TGenericTree.DeleteNode(todeletenode:TGenericTreeNode;mode:integer):boolean;
var  previousnode:TGenericTreeNode; i,n:integer;
begin
 previousnode:=todeletenode.fpredecessor;
 if previousnode<>nil then begin
 // deleter le node comme successeur du précédent
  previousnode.deletesuccessor(toDeleteNode);
 // changer le predecesseur de tous les successeurs et ajouter les successeur à la liste des successeurs
 // du précédent.
  for i:=0 to todeletenode.fsuccessors.count -1 do
  begin
   previousnode.addsuccessor(TGenericTreeNode(toDeleteNode.fsuccessors.list[i]));
   TGenericTreeNode(toDeleteNode.fsuccessors.list[i]).fpredecessor:=previousnode;
  end;
   toDeleteNode.delete(mode);
 end else begin //roots
  n:=todeletenode.fsuccessors.count-1;
  for i:=0 to n do
   PromoteRoot(TGenericTreeNode(todeletenode.fsuccessors.list[i]));

  DeleteRoot(todeletenode,mode);
 end;
 result:=true;

end;
function TGenericTree.DeleteRoot(node:TGenericTreeNode;mode:integer):boolean;
var i:integer;
begin
      // enlever le node de la list des racines
   for i:=0 to froots.count -1 do
    if TGenericTreeNode(froots.list[i]).id_node=node.id_node then
    begin
     froots.delete(i);
     break;
    end;
    node.delete(mode);
    result:=true;
end;

function TGenericTree.AttachNodeTo(sourcenode,targetnode:TGenericTreeNode):boolean;
var prevnode:TGenericTreeNode;
begin
 try
  prevnode:=sourcenode.fpredecessor;
  if prevnode<>nil then
   prevnode.deletesuccessor(sourcenode);
  targetnode.addsuccessor(sourcenode);
  sourcenode.fpredecessor:=targetnode;
  result:=true;
 except
  result:=false;
 end;
end;
function TGenericTree.AttachNodeTo(sourcenode_id:integer;targetnode:TGenericTreeNode):boolean;
var sourcenode:TGenericTreeNode;
begin
 try
  sourcenode:=FindNode(sourcenode_id);
  AttachNodeTo(sourcenode,targetnode);
  result:=true;
 except
  result:=false;
 end;
end;
procedure TGenericTreeNode.DeleteAllSuccessor;
begin
 fsuccessors.clear;
end;
function TGenericTree.AttachnodeTo(sourcenode_id,targetnode_id:integer):boolean;
var sourcenode,targetnode:TGenericTreeNode;
begin
 try
  sourcenode:=FindNode(sourcenode_id);
  targetnode:=FindNode(targetnode_id);
  AttachNodeTo(sourcenode,targetnode);
  result:=true;
 except
  result:=false;
 end;

end;

function TGenericTree.deletenode(node:TGenericTreeNode):boolean;
begin
 result:=deletenode(node,0);
end;

{$T-}
function TGenericTree.AddRefRoot(data: TGenericTreeNode): TGenericTreeNode;
begin

  result:=TGenericTreeNode(froots.AddRef(data));

end;

{ TGenericItemList }

procedure TGenericItemList.clone(v: TGenericItemList);
begin
// must be implemented in the child class
end;

constructor TGenericItemList.create;
begin

end;

{ TGenericList }

function TGenericList.Add:TGenericItemList;
begin
// must be implemented in the child class in the following way
// TChildClass.add;
// begin
//   item:=TnewChildClassTreeNode.create;
//   AddRef(item);
// end;
 result:=nil;
end;

function TGenericList.Add(item: TGenericItemList):TGenericItemList;
var tmp:TGenericItemList;
begin
   tmp:=Add;
   tmp.clone(item);
// must be implemented in the child class in the following way
// begin
//   tmp:=Add;
//   tmp.clone(TnewChildClassTreeNode(item));
// end;
 result:=nil;
end;


function TGenericList.AddRef(item: TGenericItemList):TGenericItemList;
begin
 fcount:=fcount+1;
 SetLength(flist,fcount);
 flist[fcount-1]:=item;
 result:=flist[fcount-1];
end;

procedure TGenericList.clear;
begin
 Setlength(flist,0);
 fcount:=0;
end;

constructor TGenericList.create;
begin
 fcount:=0;
end;

function TGenericList.Delete(index: integer): boolean;
var i:integer;
begin
 if index>count -1 then
  result:=false else result:=true;
 if index<count-1 then
 begin
  for i:=index+1 to count -1 do
   flist[i-1]:=flist[i];
  fcount:=fcount-1;
  setlength(flist,fcount);
 end else
  if index=count-1 then
  begin
   dec(fcount);
   setlength(flist,fcount);
  end;
end;

function TGenericList.Delete(item: TGenericItemList): boolean;
var i,index:integer;
begin
 index:=-1;
 for i:=0 to count -1 do
  if item=flist[i] then
  begin
   index:=i;
   break;
  end;
  if not (index<0) then
   result:=Delete(index) else result:=false;
end;

destructor TGenericList.destroy;
begin
  inherited;
  setlength(flist,0);
  fcount:=0;
end;

function TGenericList.getList(i:integer): TgenericItemList;
begin
 result:=flist[i];
end;


end.