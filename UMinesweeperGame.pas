unit UMinesweeperGame;

interface

uses
  UMinesweeperDataController, Vcl.Forms, UDogFrame, UBoardFrame;

type
  TMinesweeperGame = class
  private
    fDataController: TMineSweeperDataController;
    fMainWindow: TForm;
    fDogFrame: TDogFrame;
    fBoardFrame: TBoardFrame;
    fBoardWidth, fBoardHeight: Integer;
    fNumberOfMines: Integer;

    procedure DataControllerOnRestartRequired(Sender: TObject);
    procedure DataControllerOnVictory(Sender: TObject);

  public
    constructor Create(aMainWindow: TForm; aDogFrame: TDogFrame; aBoardFrame: TBoardFrame);

    destructor Destroy(); override;

    procedure NewGame();
    function GetGameTime(): TDateTime;
    function GetUserRemainingMines(): Integer;
    procedure HelpAreFlagsGood();

    property BoardWidth: Integer read fBoardWidth write fBoardWidth;
    property BoardHeight: Integer read fBoardHeight write fBoardHeight;
    property NumberOfMines: Integer read fNumberOfMines write fNumberOfMines;
  end;

implementation

uses
  System.SysUtils, UHighScoresForm, Vcl.Dialogs;

{ TMinesweeperGame }

constructor TMinesweeperGame.Create(aMainWindow: TForm; aDogFrame: TDogFrame; aBoardFrame: TBoardFrame);
begin
  fMainWindow := aMainWindow;
  fDogFrame := aDogFrame;
  fBoardFrame := aBoardFrame;
  fBoardWidth := 10;
  fBoardHeight := 10;
  fNumberOfMines := 20;
end;

procedure TMinesweeperGame.DataControllerOnRestartRequired(Sender: TObject);
begin
  NewGame();
end;

procedure TMinesweeperGame.DataControllerOnVictory(Sender: TObject);
begin
  var highScoresForm := THighScoresForm.Create(nil);
  try
    highScoresForm.LoadForConfig(BoardWidth, BoardHeight, NumberOfMines);
    highScoresForm.NewScore(GetGameTime());
    highScoresForm.ShowModal();
  finally
    FreeAndNil(highScoresForm);
  end;
end;

destructor TMinesweeperGame.Destroy;
begin
  FreeAndNil(fDataController);

  inherited;
end;

function TMinesweeperGame.GetGameTime: TDateTime;
begin
  if fDataController.IsRunning then
    result := fDataController.GetEndTime() - fDataController.GetStartTime()
  else
    result := 0;
end;

function TMinesweeperGame.GetUserRemainingMines: Integer;
begin
  result := fDataController.GetNumberOfMines() - fDataController.GetNumberOfFlags();
end;

procedure TMinesweeperGame.HelpAreFlagsGood;
begin
  if fDataController.CheckFlagCorrectness() then
    ShowMessage('The all-knowing dog thinks your flags are good.')
  else
    ShowMessage('The all-knowing dog does not like your flags.');
end;

procedure TMinesweeperGame.NewGame;
begin
  var newDataController := TMineSweeperDataController.Create(fBoardWidth, fBoardHeight, fNumberOfMines);
  newDataController.OnRestartRequired := DataControllerOnRestartRequired;
  newDataController.OnVictory := DataControllerOnVictory;
  fBoardFrame.Controller := newDataController;
  fDogFrame.Controller := newDataController;

  FreeAndNil(fDataController);
  fDataController := newDataController;
  fMainWindow.ClientWidth := fBoardFrame.Left + fBoardFrame.GetPreferredWidth();
  fMainWindow.ClientHeight := fBoardFrame.Top + fBoardFrame.GetPreferredHeight();
end;

end.
