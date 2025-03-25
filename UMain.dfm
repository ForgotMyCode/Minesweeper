object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Minesweeper'
  ClientHeight = 463
  ClientWidth = 632
  Color = clBtnFace
  Constraints.MinHeight = 160
  Constraints.MinWidth = 210
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 65
    Align = alTop
    Caption = 'Panel1'
    Color = 11783167
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      632
      65)
    object lblTime: TLabel
      Left = 8
      Top = 21
      Width = 105
      Height = 21
      Caption = '00:00:00'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = 4227072
      Font.Height = -16
      Font.Name = 'Yu Gothic'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMines: TLabel
      Left = 552
      Top = 21
      Width = 67
      Height = 21
      Anchors = [akTop, akRight]
      BiDiMode = bdRightToLeft
      Caption = '999'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = 4194432
      Font.Height = -16
      Font.Name = 'Yu Gothic'
      Font.Style = [fsBold]
      ParentBiDiMode = False
      ParentFont = False
    end
    inline DogFrame1: TDogFrame
      Left = 256
      Top = 16
      Width = 44
      Height = 44
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      ExplicitLeft = 256
      ExplicitTop = 16
    end
  end
  inline BoardFrame1: TBoardFrame
    Left = 0
    Top = 65
    Width = 632
    Height = 398
    Align = alClient
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    ExplicitTop = 65
    ExplicitWidth = 632
    ExplicitHeight = 398
    inherited PaintBox1: TPaintBox
      Width = 632
      Height = 398
    end
  end
  object MainMenu1: TMainMenu
    OwnerDraw = True
    Left = 120
    Top = 65528
    object Game1: TMenuItem
      Caption = 'Game'
      object NewGame1: TMenuItem
        Caption = '&New Game'
        OnClick = NewGame1Click
      end
      object HighScores1: TMenuItem
        Caption = 'High Scores'
        OnClick = HighScores1Click
      end
      object HelpAremyflagsgood1: TMenuItem
        Caption = 'Help: Are my flags good?'
        OnClick = HelpAremyflagsgood1Click
      end
      object NewGame2: TMenuItem
        Caption = '&Exit'
        OnClick = NewGame2Click
      end
    end
    object Board1: TMenuItem
      Caption = 'Board'
      object Small1: TMenuItem
        Caption = 'Small'
        GroupIndex = 1
        RadioItem = True
        OnClick = Small1Click
      end
      object Medium1: TMenuItem
        Caption = 'Medium'
        GroupIndex = 1
        RadioItem = True
        OnClick = Medium1Click
      end
      object Medium2: TMenuItem
        Caption = 'Large'
        GroupIndex = 1
        RadioItem = True
        OnClick = Medium2Click
      end
      object Custom1: TMenuItem
        Caption = 'Custom...'
        GroupIndex = 1
        OnClick = Custom1Click
      end
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 488
    Top = 8
  end
end
