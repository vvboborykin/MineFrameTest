object ExportForm: TExportForm
  Left = 0
  Top = 0
  Caption = #1069#1082#1089#1087#1086#1088#1090
  ClientHeight = 199
  ClientWidth = 498
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
  OnCreate = FormCreate
  TextHeight = 21
  object btnStart: TButton
    Left = 10
    Top = 147
    Width = 478
    Height = 42
    Action = actStart
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 216
    ExplicitWidth = 604
  end
  object rgFormats: TRadioGroup
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 478
    Height = 127
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 10
    Align = alClient
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1086#1088#1084#1072#1090' '#1101#1082#1089#1087#1086#1088#1090#1072' '#1076#1072#1085#1085#1099#1093
    TabOrder = 1
    ExplicitLeft = 64
    ExplicitTop = 24
    ExplicitWidth = 185
    ExplicitHeight = 105
  end
  object aclMain: TActionList
    Left = 336
    Top = 8
    object actStart: TAction
      Caption = #1053#1072#1095#1072#1090#1100' '#1101#1082#1089#1087#1086#1088#1090
      OnExecute = actStartExecute
      OnUpdate = actStartUpdate
    end
  end
end
