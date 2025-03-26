program Minesweeper_proj;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Form1},
  UMinesweeperDataController in 'UMinesweeperDataController.pas',
  UMinesweeperGame in 'UMinesweeperGame.pas',
  UDoubleBufferedFrame in 'UDoubleBufferedFrame.pas' {DoubleBufferedFrame: TFrame},
  UBoardFrame in 'UBoardFrame.pas' {BoardFrame: TFrame},
  UDogFrame in 'UDogFrame.pas' {DogFrame: TFrame},
  UCustomBoardForm in 'UCustomBoardForm.pas' {CustomBoardForm},
  UHighScoresForm in 'UHighScoresForm.pas' {HighScoresForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
