object BaseContextEditor: TBaseContextEditor
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1101#1082#1089#1087#1086#1088#1090#1072
  ClientHeight = 311
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Padding.Left = 10
  Padding.Top = 10
  Padding.Right = 10
  Padding.Bottom = 10
  Position = poScreenCenter
  TextHeight = 21
  object btnStart: TButton
    AlignWithMargins = True
    Left = 10
    Top = 207
    Width = 489
    Height = 42
    Margins.Left = 0
    Margins.Top = 10
    Margins.Right = 0
    Margins.Bottom = 0
    Action = actStart
    Align = alBottom
    Default = True
    ModalResult = 1
    TabOrder = 0
    ExplicitTop = 258
    ExplicitWidth = 485
  end
  object btnCancel: TButton
    AlignWithMargins = True
    Left = 10
    Top = 259
    Width = 489
    Height = 42
    Margins.Left = 0
    Margins.Top = 10
    Margins.Right = 0
    Margins.Bottom = 0
    Action = actCancel
    Align = alBottom
    Default = True
    ModalResult = 2
    TabOrder = 1
    ExplicitLeft = 7
    ExplicitTop = 256
  end
  object aclMain: TActionList
    Left = 368
    Top = 80
    object actStart: TAction
      Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
      OnExecute = actStartExecute
    end
    object actCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = actCancelExecute
    end
  end
end
