object CustomBoardForm: TCustomBoardForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Custom Board'
  ClientHeight = 144
  ClientWidth = 230
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 11
    Width = 32
    Height = 15
    Caption = 'Width'
  end
  object Label2: TLabel
    Left = 24
    Top = 41
    Width = 36
    Height = 15
    Caption = 'Height'
  end
  object Label3: TLabel
    Left = 24
    Top = 71
    Width = 32
    Height = 15
    Caption = 'Mines'
  end
  object seWidth: TSpinEdit
    Left = 88
    Top = 8
    Width = 121
    Height = 24
    MaxValue = 999
    MinValue = 1
    TabOrder = 0
    Value = 0
  end
  object seHeight: TSpinEdit
    Left = 88
    Top = 38
    Width = 121
    Height = 24
    MaxValue = 999
    MinValue = 1
    TabOrder = 1
    Value = 0
  end
  object seMines: TSpinEdit
    Left = 88
    Top = 68
    Width = 121
    Height = 24
    MaxValue = 999
    MinValue = 1
    TabOrder = 2
    Value = 0
  end
  object Button1: TButton
    Left = 8
    Top = 111
    Width = 75
    Height = 25
    Caption = 'Confirm'
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 147
    Top = 111
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
