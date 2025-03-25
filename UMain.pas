unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPickers, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.StdCtrls, UBoardFrame, UMinesweeperGame,
  UDoubleBufferedFrame, Vcl.Menus, UDogFrame;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    BoardFrame1: TBoardFrame;
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    NewGame1: TMenuItem;
    NewGame2: TMenuItem;
    Board1: TMenuItem;
    Small1: TMenuItem;
    Medium1: TMenuItem;
    Medium2: TMenuItem;
    Timer1: TTimer;
    lblTime: TLabel;
    lblMines: TLabel;
    DogFrame1: TDogFrame;
    Custom1: TMenuItem;
    HighScores1: TMenuItem;
    HelpAremyflagsgood1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure NewGame2Click(Sender: TObject);
    procedure NewGame1Click(Sender: TObject);
    procedure Small1Click(Sender: TObject);
    procedure Medium1Click(Sender: TObject);
    procedure Medium2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Custom1Click(Sender: TObject);
    procedure HighScores1Click(Sender: TObject);
    procedure HelpAremyflagsgood1Click(Sender: TObject);
  private
    { Private declarations }
    fGame: TMinesweeperGame;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  UCustomBoardForm, UHighScoresForm;

{$R *.dfm}

procedure TForm1.Custom1Click(Sender: TObject);
begin
  var customBoardForm := TCustomBoardForm.create(nil);
  try
    customBoardForm.seWidth.Value := fGame.BoardWidth;
    customBoardForm.seHeight.Value := fGame.BoardHeight;
    customBoardForm.seMines.Value := fGame.NumberOfMines;

    if customBoardForm.ShowModal <> mrOk then
      Exit();

    fGame.BoardWidth := customBoardForm.seWidth.Value;
    fGame.BoardHeight := customBoardForm.seHeight.Value;
    fGame.NumberOfMines := customBoardForm.seMines.Value;

    fGame.NewGame();

  finally
    FreeAndNil(customBoardForm);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  fGame := TMinesweeperGame.Create(Self, DogFrame1, BoardFrame1);
  fGame.NewGame();
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  DogFrame1.Left := (ClientWidth - DogFrame1.Width) div 2;
end;

procedure TForm1.HelpAremyflagsgood1Click(Sender: TObject);
begin
  fGame.HelpAreFlagsGood();
end;

procedure TForm1.HighScores1Click(Sender: TObject);
begin
  var highScoresForm := THighScoresForm.Create(nil);
  try
    highScoresForm.LoadForConfig(fGame.BoardWidth, fGame.BoardHeight, fGame.NumberOfMines);
    highScoresForm.ShowModal();
  finally
    FreeAndNil(highScoresForm);
  end;
end;

procedure TForm1.Medium1Click(Sender: TObject);
begin
  fGame.BoardWidth := 20;
  fGame.BoardHeight := 20;
  fGame.NumberOfMines := 75;
  fGame.NewGame();
end;

procedure TForm1.Medium2Click(Sender: TObject);
begin
  fGame.BoardWidth := 80;
  fGame.BoardHeight := 40;
  fGame.NumberOfMines := 500;
  fGame.NewGame();
end;

procedure TForm1.NewGame1Click(Sender: TObject);
begin
  fGame.NewGame();
end;

procedure TForm1.NewGame2Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.Small1Click(Sender: TObject);
begin
  fGame.BoardWidth := 10;
  fGame.BoardHeight := 10;
  fGame.NumberOfMines := 20;
  fGame.NewGame();
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  var timeStr: String;
  DateTimeToString(timeStr, 'hh:mm:ss', fGame.GetGameTime());
  lblTime.Caption := timeStr;

  lblMines.Caption := IntToStr(fGame.GetUserRemainingMines());
end;

end.
