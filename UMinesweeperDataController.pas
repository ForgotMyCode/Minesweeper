unit UMinesweeperDataController;

interface

uses
  System.Generics.Collections, System.Classes;

type
  TMineSweeperGameState = (mgsIdle, mgsLeftClick, mgsExploded, mgsVictory);

  TMineSweeperDataController = class;

  TMineField = class
  private
    fNumberOfMinesAroundCache: Integer;
    fIsFlagged: Boolean;

    procedure SetFlagged(aValue: Boolean);
  public
    HasMine: Boolean;
    IsRevealed: Boolean;
    IsExplosionSource: Boolean;
    Controller: TMineSweeperDataController;
    X, Y: Integer;

    property IsFlagged: Boolean read fIsFlagged write SetFlagged;

    function GetNumberOfMinesAround(): Integer;
    procedure SwapMinesWith(aOther: TMineField);
    procedure OnLeftClicking();
    procedure OnLeftClicked();
    procedure OnRightClicked();

    constructor Create(aController: TMineSweeperDataController; aX, aY: Integer);
  end;

  TMineSweeperDataController = class
  private
    fWidth, fHeight: Integer;
    fNumberOfMines: Integer;
    fNumberOfFlags: Integer;
    fNumberOfRevealedFields: Integer;
    fGameBoard: TObjectList<TObjectList<TMineField>>;
    fGameState: TMineSweeperGameState;
    fOnRestartRequired: TNotifyEvent;
    fOnVictory: TNotifyEvent;
    fIsRunning: Boolean;
    fStartTime: TDateTime;
    fEndTime: TDateTime;

  public
    constructor Create(aWidth, aHeight, aNumOfMines: Integer);

    function IsInBounds(aX, aY: Integer): Boolean;
    function GetFieldAt(aX, aY: Integer): TMineField;
    function GetWidth(): Integer;
    function GetHeight(): Integer;
    function GetSize(): Integer;
    function GetNumberOfMines: Integer;
    function GetNumberOfRevealedFields(): Integer;
    function GetGameBoard: TObjectList<TObjectList<TMineField>>;
    function GetStartTime: TDateTime;
    function GetEndTime: TDateTime;
    function IsGameOver: Boolean;
    function IsVictory: Boolean;
    function GetNumberOfFlags: Integer;
    function CheckFlagCorrectness: Boolean;
    procedure Shuffle();
    procedure OnLeftClicking();
    procedure OnLeftClicked(aSender: TMineField);
    procedure OnRightClicked(aSender: TMineField);
    procedure OnFlagged(aSender: TMineField);
    procedure OnUnFlagged(aSender: TMineField);

    property GameState: TMineSweeperGameState read fGameState write fGameState;
    property OnRestartRequired: TNotifyEvent read fOnRestartRequired write fOnRestartRequired;
    property OnVictory: TNotifyEvent read fOnVictory write fOnVictory;
    property IsRunning: Boolean read fIsRunning;
  end;


implementation

uses
  System.SysUtils, UMinesweeperGame, System.Math;

{ TMineSweeperDataController }

function TMineSweeperDataController.CheckFlagCorrectness: Boolean;
begin
   for var y := 0 to GetHeight() - 1 do
    for var x := 0 to GetWidth() - 1 do
    begin
      var currentField := GetFieldAt(x, y);
      if currentField.IsFlagged and not currentField.HasMine then
        Exit(False);
    end;

    result := True;
end;

constructor TMineSweeperDataController.Create(aWidth, aHeight,
  aNumOfMines: Integer);
begin
  if (aNumOfMines <= 0) or (aNumOfMines >= (aWidth * aHeight)) then
    raise Exception.Create('Invalid amount of mines.');

  if (aHeight <= 0) then
    raise Exception.Create('Invalid height.');

  if (aWidth <= 0) then
    raise Exception.Create('Invalid width.');

  fWidth := aWidth;
  fHeight := aHeight;
  fGameBoard := TObjectList<TObjectList<TMineField>>.Create();
  fNumberOfMines := aNumOfMines;

  for var y := 0 to aHeight - 1 do
  begin
    var row := TObjectList<TMineField>.Create();
    fGameBoard.Add(row);

    for var x := 0 to aWidth - 1 do
    begin
      var field := TMineField.Create(Self, x, y);
      row.Add(field);
    end;
  end;

  for var i := 0 to aNumOfMines - 1 do
  begin
    var y := i div aWidth;
    var x := i mod aWidth;
    GetFieldAt(x, y).HasMine := True;
  end;

  Shuffle();
end;

function TMineSweeperDataController.GetEndTime: TDateTime;
begin
  if IsGameOver then
    result := fEndTime
  else
    result := Now();
end;

function TMineSweeperDataController.GetFieldAt(aX, aY: Integer): TMineField;
begin
  if not IsInBounds(aX, aY) then
    raise Exception.Create('Position out of bounds.');

  result := GetGameBoard()[aY][aX];
end;

function TMineSweeperDataController.GetGameBoard: TObjectList<TObjectList<TMineField>>;
begin
  result := fGameBoard;
end;

function TMineSweeperDataController.GetHeight: Integer;
begin
  result := fHeight;
end;

function TMineSweeperDataController.GetNumberOfFlags: Integer;
begin
  result := fNumberOfFlags;
end;

function TMineSweeperDataController.GetNumberOfMines: Integer;
begin
  result := fNumberOfMines;
end;

function TMineSweeperDataController.GetNumberOfRevealedFields: Integer;
begin
  result := fNumberOfRevealedFields;
end;

function TMineSweeperDataController.GetSize: Integer;
begin
  result := GetWidth() * GetHeight();
end;

function TMineSweeperDataController.GetStartTime: TDateTime;
begin
  result := fStartTime;
end;

function TMineSweeperDataController.GetWidth: Integer;
begin
  result := fWidth;
end;

function TMineSweeperDataController.IsGameOver: Boolean;
begin
  result := GameState in [mgsExploded, mgsVictory];
end;

function TMineSweeperDataController.IsInBounds(aX, aY: Integer): Boolean;
begin
  result := (
    (aX >= 0) and
    (aY >= 0) and
    (aX < GetWidth()) and
    (aY < GetHeight())
  );
end;

function TMineSweeperDataController.IsVictory: Boolean;
begin
  result := (GetNumberOfMines() + GetNumberOfRevealedFields()) >= GetSize();
end;

procedure TMineSweeperDataController.OnFlagged(aSender: TMineField);
begin
  Inc(fNumberOfFlags);
end;

procedure TMineSweeperDataController.OnLeftClicked(aSender: TMineField);
  procedure _expand(aX, aY: Integer);
  begin
    if not IsInBounds(aX, aY) then
      Exit();

    var field := GetFieldAt(aX, aY);

    if field.IsRevealed then
      Exit();

    field.IsRevealed := True;
    field.IsFlagged := False;
    Inc(fNumberOfRevealedFields);

    if field.GetNumberOfMinesAround() = 0 then
      for var dy := -1 to 1 do
        for var dx := -1 to 1 do
        begin
          var xx := aX + dx;
          var yy := aY + dy;

          _expand(xx, yy);
        end;
  end;

begin
  if IsGameOver then
  begin
    if Assigned(fOnRestartRequired) then
      fOnRestartRequired(Self);

    Exit;
  end;

  if not fIsRunning then
  begin
    fIsRunning := True;
    fStartTime := Now();
  end;

  GameState := mgsIdle;

  if aSender.HasMine then
  begin
    aSender.IsExplosionSource := True;
    fEndTime := Now();
    GameState := mgsExploded;

    for var y := 0 to GetHeight() - 1 do
      for var x := 0 to GetWidth() - 1 do
      begin
        var field := GetFieldAt(x, y);
        if (field.HasMine) then
          field.IsRevealed := True;
      end;

  end
  else
  begin
    _expand(aSender.X, aSender.Y);

    if IsVictory() then
    begin
      fEndTime := Now();
      GameState := mgsVictory;
      if Assigned(OnVictory) then
        OnVictory(Self);
    end;
  end;
end;

procedure TMineSweeperDataController.OnLeftClicking;
begin
  if GameState = mgsIdle then
    GameState := mgsLeftClick;
end;

procedure TMineSweeperDataController.OnRightClicked(aSender: TMineField);
begin
  if (not IsGameOver()) and (not aSender.IsRevealed) then
    aSender.IsFlagged := not aSender.IsFlagged;
end;

procedure TMineSweeperDataController.OnUnFlagged(aSender: TMineField);
begin
  Dec(fNumberOfFlags);
end;

procedure TMineSweeperDataController.Shuffle;
begin
  for var y := 0 to GetHeight() - 1 do
    for var x := 0 to GetWidth() - 1 do
    begin
      var currentField := GetFieldAt(x, y);
      var targetField := GetFieldAt(Random(GetWidth()), Random(GetHeight()));
      currentField.SwapMinesWith(targetField);
    end;
end;

constructor TMineField.Create(aController: TMineSweeperDataController; aX, aY: Integer);
begin
  Controller := aController;
  X := aX;
  Y := aY;
  fNumberOfMinesAroundCache := -1;
end;

function TMineField.GetNumberOfMinesAround: Integer;
begin
  if fNumberOfMinesAroundCache <> -1 then
    Exit(fNumberOfMinesAroundCache);

  result := 0;

  for var dy := -1 to 1 do
    for var dx := -1 to 1 do
    begin
      if(dy = 0) and (dx = 0) then
        Continue;

      var xx := X + dx;
      var yy := Y + dy;

      if(Controller.IsInBounds(xx, yy) and (Controller.GetFieldAt(xx, yy).HasMine)) then
        Inc(result);
    end;

  fNumberOfMinesAroundCache := result;
end;

procedure TMineField.OnLeftClicked;
begin
  Controller.OnLeftClicked(Self);
end;

procedure TMineField.OnLeftClicking;
begin
  Controller.OnLeftClicking();
end;

procedure TMineField.OnRightClicked;
begin
  Controller.OnRightClicked(Self);
end;

procedure TMineField.SetFlagged(aValue: Boolean);
begin
  if fIsFlagged = aValue then
    Exit;

  fIsFlagged := aValue;

  if aValue then
    Controller.OnFlagged(Self)
  else
    Controller.OnUnFlagged(Self);
end;

procedure TMineField.SwapMinesWith(aOther: TMineField);
begin
  var tmp := HasMine;
  HasMine := aOther.HasMine;
  aOther.HasMine := tmp;
end;

end.
