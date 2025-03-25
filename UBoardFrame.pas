unit UBoardFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UDoubleBufferedFrame, Vcl.ExtCtrls, UMinesweeperDataController,
  System.ImageList, Vcl.ImgList;

type
  TBoardFrame = class(TDoubleBufferedFrame)
    Timer1: TTimer;
    ImageList_Fields: TImageList;
    procedure Timer1Timer(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }

    fController: TMineSweeperDataController;
    fFocusedX: Integer;
    fFocusedY: Integer;

    function GetFieldSize(): Integer;
  protected
    procedure CanvasPaint(aCanvas: TCanvas); override;

  public
    { Public declarations }

    function GetPreferredWidth(): Integer;
    function GetPreferredHeight(): Integer;

    property Controller: TMineSweeperDataController read fController write fController;
  end;

var
  BoardFrame: TBoardFrame;

implementation

uses
  System.Math;

{$R *.dfm}

procedure TBoardFrame.CanvasPaint(aCanvas: TCanvas);
begin
  inherited;

  aCanvas.Brush.Color := clBlack;
  aCanvas.FillRect(aCanvas.ClipRect);

  if not Assigned(Controller) then
    Exit();

  for var y := 0 to Controller.GetHeight() - 1 do
    for var x := 0 to Controller.GetWidth() - 1 do
    begin
      var canvasY := y * GetFieldSize();
      var canvasX := x * GetFieldSize();
      var field := Controller.GetFieldAt(x, y);

      var imageIndex := 0;

      if not field.IsRevealed then
        imageIndex := IfThen(field.IsFlagged, 1, 0)
      else
      begin

        if field.HasMine then
        begin
          if field.IsExplosionSource then
            imageIndex := 12
          else if field.IsFlagged then
            imageIndex := 13
          else
            imageIndex := 11;
        end
        else
          imageIndex := field.GetNumberOfMinesAround() + 2;

      end;

      ImageList_Fields.Draw(aCanvas, canvasX, canvasY, imageIndex);

    end;

    aCanvas.Brush.Color := clWhite;
    aCanvas.FrameRect(TRect.Create(
      fFocusedX*GetFieldSize(),
      fFocusedY*GetFieldSize(),
      (fFocusedX+1)*GetFieldSize(),
      (fFocusedY+1)*GetFieldSize()
    ));
end;

function TBoardFrame.GetFieldSize: Integer;
begin
  result := ImageList_Fields.Width;
end;

function TBoardFrame.GetPreferredHeight: Integer;
begin
  result := GetFieldSize() * Controller.GetHeight();
end;

function TBoardFrame.GetPreferredWidth: Integer;
begin
  result := GetFieldSize() * Controller.GetWidth();
end;

procedure TBoardFrame.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  fFocusedX := X div GetFieldSize();
  fFocusedY := Y div GetFieldSize();
end;

procedure TBoardFrame.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  var fieldX := X div GetFieldSize();
  var fieldY := Y div GetFieldSize();

  if not Controller.IsInBounds(fieldX, fieldY) then
    Exit();

  var field := Controller.GetFieldAt(fieldX, fieldY);

  if Button = mbLeft then
    field.OnLeftClicked();
end;

procedure TBoardFrame.PaintBox2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;

  var fieldX := X div GetFieldSize();
  var fieldY := Y div GetFieldSize();

  if not Controller.IsInBounds(fieldX, fieldY) then
    Exit();

  var field := Controller.GetFieldAt(fieldX, fieldY);

  if Button = mbLeft then
    field.OnLeftClicking();

  if Button = mbRight then
    field.OnRightClicked();
end;

procedure TBoardFrame.Timer1Timer(Sender: TObject);
begin
  inherited;

  Redraw();
end;

end.
