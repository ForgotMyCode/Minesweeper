unit UCustomBoardForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin;

type
  TCustomBoardForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    seWidth: TSpinEdit;
    seHeight: TSpinEdit;
    seMines: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TCustomBoardForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
  procedure _ShowErr(aMsg: String);
  begin
    MessageDlg(aMsg, TMsgDlgType.mtError, [mbOk], 0);
  end;

begin
  CanClose := True;

  if ModalResult <> mrOk then
  begin
    Exit();
  end;

  if (seWidth.Value <= 0) or (seHeight.Value <= 0) then
  begin
    _ShowErr('Invalid board size.');
    CanClose := False;
    Exit();
  end;

  if (seMines.Value <= 0) or (seMines.Value >= (seWidth.Value * seHeight.Value)) then
  begin
    _ShowErr('Invalid amount of mines.');
    CanClose := False;
    Exit();
  end;

end;

end.
