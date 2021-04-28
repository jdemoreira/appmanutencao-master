object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'fThreads'
  ClientHeight = 285
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 13
    Top = 32
    Width = 81
    Height = 13
    Caption = 'Numero threads:'
  end
  object Label2: TLabel
    Left = 13
    Top = 59
    Width = 36
    Height = 13
    Caption = 'Tempo:'
  end
  object edtNumTheads: TEdit
    Left = 100
    Top = 24
    Width = 264
    Height = 21
    TabOrder = 0
  end
  object edtTempo: TEdit
    Left = 100
    Top = 51
    Width = 264
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 16
    Top = 78
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 109
    Width = 489
    Height = 89
    TabOrder = 3
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 248
    Width = 489
    Height = 17
    TabOrder = 4
  end
end
