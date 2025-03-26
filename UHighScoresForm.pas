unit UHighScoresForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  THighScoresForm = class(TForm)
    Label1: TLabel;
    lblBoardSize: TLabel;
    Label3: TLabel;
    lblMines: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    lblPlace1Name: TLabel;
    lblPlace2Name: TLabel;
    lblPlace3Name: TLabel;
    Button1: TButton;
    lblTime1: TLabel;
    lblTime2: TLabel;
    lblTime3: TLabel;
  private
    { Private declarations }
    fPlace1Time: TDateTIme;
    fPlace2Time: TDateTime;
    fPlace3Time: TDateTime;
    fWidth, fHeight, fMines: Integer;

    function GetSectionKey(): String;
  public
    { Public declarations }
    procedure LoadForConfig(aWidth, aHeight, aMines: Integer);
    procedure NewScore(aScore: TDateTime);
  end;

implementation

uses
  IniFiles, DateUtils;

{$R *.dfm}

{ THighScoresForm }

function THighScoresForm.GetSectionKey: String;
begin
  result := IntToStr(fWidth) + '/' + IntToStr(fHeight) + '/' + IntToStr(fMines);
end;

procedure THighScoresForm.LoadForConfig(aWidth, aHeight, aMines: Integer);
begin
  fWidth := aWidth;
  fHeight := aHeight;
  fMines := aMines;

  lblBoardSize.Caption := IntToStr(fWidth) + 'x' + IntToStr(fHeight);
  lblMines.Caption := IntToStr(fMines);

  var ini := TIniFile.Create('./highscores.ini');

  try
    var key := GetSectionKey();

    fPlace1Time := ini.ReadDateTime(key, 'Place1Time', EncodeTime(23, 59, 59, 0));
    fPlace2Time := ini.ReadDateTime(key, 'Place2Time', EncodeTime(23, 59, 59, 0));
    fPlace3Time := ini.ReadDateTime(key, 'Place3Time', EncodeTime(23, 59, 59, 0));

    lblPlace1Name.Caption := ini.ReadString(key, 'Place1Name', '<Nobody>');
    lblPlace2Name.Caption := ini.ReadString(key, 'Place2Name', '<Nobody>');
    lblPlace3Name.Caption := ini.ReadString(key, 'Place3Name', '<Nobody>');

    var place1timeStr: String;
    var place2timeStr: String;
    var place3timeStr: String;
    DateTimeToString(place1timeStr, 'hh:mm:ss', fPlace1Time);
    DateTimeToString(place2timeStr, 'hh:mm:ss', fPlace2Time);
    DateTimeToString(place3timeStr, 'hh:mm:ss', fPlace3Time);
    lblTime1.Caption := place1timeStr;
    lblTime2.Caption := place2timeStr;
    lblTime3.Caption := place3timeStr;
  finally
    FreeAndNil(ini);
  end;
end;

procedure THighScoresForm.NewScore(aScore: TDateTime);
  function _getUserName(): String;
  begin
    InputQuery('New high score!', 'What is your name?', result);
  end;
begin

  // Is score worse than 3rd place? -> exit
  if aScore >= fPlace3Time then
    Exit();

  var userName := _getUserName();

  fPlace3Time := aScore;
  lblPlace3Name.Caption := userName;

  // Promote to 2nd
  if aScore < fPlace2Time then
  begin
    fPlace3Time := fPlace2Time;
    lblPlace3Name.Caption := lblPlace2Name.Caption;

    fPlace2Time := aScore;
    lblPlace2Name.Caption := userName;
  end;

  // Promote to 1st
  if aScore < fPlace1Time then
  begin
    fPlace2Time := fPlace1Time;
    lblPlace2Name.Caption := lblPlace1Name.Caption;

    fPlace1Time := aScore;
    lblPlace1Name.Caption := userName;
  end;

  // Write
  var key := GetSectionKey();

  var ini := TIniFile.Create('./highscores.ini');
  try
    ini.WriteString(key, 'Place1Name', lblPlace1Name.Caption);
    ini.WriteString(key, 'Place2Name', lblPlace2Name.Caption);
    ini.WriteString(key, 'Place3Name', lblPlace3Name.Caption);

    ini.WriteDateTime(key, 'Place1Time', fPlace1Time);
    ini.WriteDateTime(key, 'Place2Time', fPlace2Time);
    ini.WriteDateTime(key, 'Place3Time', fPlace3Time);
  finally
    FreeAndNil(ini);
  end;

  // Reload
  LoadForConfig(fWidth, fHeight, fMines);
end;

end.
