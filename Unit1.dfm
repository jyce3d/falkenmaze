object Form1: TForm1
  Left = 192
  Top = 124
  Width = 326
  Height = 435
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 107
    Height = 16
    Caption = 'Dijkstra Algorithm:'
  end
  object imgMain: TImage
    Left = 8
    Top = 32
    Width = 297
    Height = 297
    OnMouseDown = imgMainMouseDown
  end
  object Button1: TButton
    Left = 8
    Top = 368
    Width = 177
    Height = 25
    Caption = 'Start Calculation'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 136
    Top = 336
    Width = 81
    Height = 25
    Caption = 'Start Point'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 224
    Top = 336
    Width = 81
    Height = 25
    Caption = 'Check Point'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 336
    Width = 81
    Height = 25
    Caption = 'Normal'
    TabOrder = 3
    OnClick = Button4Click
  end
end
