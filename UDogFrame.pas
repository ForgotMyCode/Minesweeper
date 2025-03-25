unit UDogFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UDoubleBufferedFrame, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, UMinesweeperDataController;

type
  TDogFrame = class(TDoubleBufferedFrame)
    ImageList1: TImageList;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    fController: TMineSweeperDataController;
  protected
    procedure CanvasPaint(aCanvas: TCanvas); override;
  public
    { Public declarations }
    property Controller: TMineSweeperDataController read fController write fController;
  end;

var
  DogFrame: TDogFrame;

implementation

uses
  System.Math;

{$R *.dfm}

procedure TDogFrame.CanvasPaint(aCanvas: TCanvas);
begin
  inherited;

  aCanvas.Brush.Color := $00B3CBFF;
  aCanvas.FillRect(aCanvas.ClipRect);

  if not Assigned(Controller) then
    Exit();

  case Controller.GameState of
    mgsIdle:
    begin
      ImageList1.Draw(aCanvas, 0, 0, 0);
      var mousePosScreen := Mouse.CursorPos;
      var mousePosClient := ScreenToClient(mousePosScreen);
      var leftEyeX := Min(18, Max(11, mousePosClient.X));
      var rightEyeX := Min(28, Max(24, mousePosClient.X));
      aCanvas.Brush.Color := $002A2B4D;
      aCanvas.Ellipse(leftEyeX, 14, leftEyeX + 5, 18);
      aCanvas.Ellipse(rightEyeX, 14, rightEyeX + 5, 18);
    end;
    mgsLeftClick:
      ImageList1.Draw(aCanvas, 0, 0, 1);
    mgsExploded:
      ImageList1.Draw(aCanvas, 0, 0, 3);
    mgsVictory:
      ImageList1.Draw(aCanvas, 0, 0, 2);
  end;
end;

procedure TDogFrame.Timer1Timer(Sender: TObject);
begin
  inherited;
  Redraw();
end;

end.
