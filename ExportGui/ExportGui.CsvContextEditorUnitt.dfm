inherited CsvContextEditor: TCsvContextEditor
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1087#1077#1088#1072#1084#1077#1090#1088#1086#1074' '#1101#1082#1089#1087#1086#1088#1090#1072' '#1074' CSV '#1092#1072#1081#1083
  ClientHeight = 391
  OnCreate = FormCreate
  ExplicitHeight = 429
  TextHeight = 21
  inherited btnStart: TButton
    Top = 287
    ExplicitTop = 141
  end
  object chkQuote: TCheckBox [3]
    AlignWithMargins = True
    Left = 10
    Top = 75
    Width = 489
    Height = 17
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 10
    Align = alTop
    Caption = #1047#1072#1082#1083#1102#1095#1072#1090#1100' '#1074' '#1082#1072#1074#1099#1095#1082#1080' '#1089#1090#1088#1086#1082#1086#1074#1099#1077' '#1079#1085#1072#1095#1077#1085#1080#1103
    TabOrder = 2
    ExplicitLeft = 40
    ExplicitTop = 160
    ExplicitWidth = 97
  end
  inherited btnCancel: TButton
    Top = 339
    TabOrder = 3
    ExplicitLeft = 10
    ExplicitTop = 186
  end
  object grpDelimiterType: TGroupBox [5]
    AlignWithMargins = True
    Left = 10
    Top = 102
    Width = 489
    Height = 175
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    Caption = #1057#1080#1084#1074#1086#1083' - '#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1074' CSV '#1092#1072#1081#1083#1077' *'
    TabOrder = 4
    ExplicitLeft = 64
    ExplicitTop = 105
    ExplicitWidth = 185
    ExplicitHeight = 105
    object rbSeicolon: TRadioButton
      Left = 16
      Top = 67
      Width = 161
      Height = 17
      Caption = #1058#1086#1095#1082#1072' '#1089' '#1079#1072#1087#1103#1090#1086#1081' (;)'
      TabOrder = 0
    end
    object rbComma: TRadioButton
      Left = 16
      Top = 101
      Width = 113
      Height = 17
      Caption = #1047#1072#1087#1103#1090#1072#1103' (,)'
      TabOrder = 1
    end
    object rbTab: TRadioButton
      Left = 16
      Top = 34
      Width = 201
      Height = 17
      Caption = #1057#1080#1084#1074#1086#1083' '#1090#1072#1073#1091#1083#1103#1094#1080#1080' (#9)'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object rbCustomDelim: TRadioButton
      Left = 16
      Top = 134
      Width = 137
      Height = 17
      Caption = #1044#1088#1091#1075#1086#1081' '#1089#1080#1084#1074#1086#1083
      TabOrder = 3
    end
    object medtDelimiter: TMaskEdit
      Left = 168
      Top = 128
      Width = 49
      Height = 29
      EditMask = 'C;1;_'
      MaxLength = 1
      TabOrder = 4
      Text = '|'
    end
  end
  inherited aclMain: TActionList
    Left = 416
    Top = 24
  end
end
