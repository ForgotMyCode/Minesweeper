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
  procedure _overwrite(aPlace: Integer);
  begin
    var userName: String;
    InputQuery('New high score!', 'What is your name?', userName);

    var ini := TInifile.Create('./highscores.ini');
    try
      ini.WriteDateTime(GetSectionKey(), 'Place' + IntToStr(aPlace) + 'Time', aScore);
      ini.WriteString(GetSectionKey(), 'Place' + IntToStr(aPlace) + 'Name', userName);
    finally
      FreeAndNil(ini);
    end;

    LoadForConfig(fWidth, fHeight, fMines);
  end;
begin
  if fPlace1Time > aScore then
    _overwrite(1)
  else if fPlace2Time > aScore then
    _overwrite(2)
  else if fPlace3Time > aScore then
    _overwrite(3);
end;

end.
