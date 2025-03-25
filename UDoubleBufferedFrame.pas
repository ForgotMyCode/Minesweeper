unit UDoubleBufferedFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TDoubleBufferedFrame = class(TFrame)
    PaintBox1: TPaintBox;
  private
    { Private declarations }
  protected

    procedure CanvasPaint(aCanvas: TCanvas); virtual; abstract;

  public
    { Public declarations }
    procedure Redraw();

    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TFrame1 }

constructor TDoubleBufferedFrame.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TDoubleBufferedFrame.Redraw();
begin
  var canvas := TBitmap.Create(PaintBox1.Canvas.ClipRect.Width, PaintBox1.Canvas.ClipRect.Height);
  try
    CanvasPaint(canvas.Canvas);
    PaintBox1.Canvas.Draw(0, 0, canvas);
  finally
    FreeAndNil(canvas);
  end;
end;

end.
