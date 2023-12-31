inherited CodePageContextEditor: TCodePageContextEditor
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1082#1086#1085#1090#1077#1082#1089#1090#1072' '#1101#1082#1089#1087#1086#1088#1090#1072' '#1089' '#1082#1086#1076#1086#1074#1086#1081' '#1090#1072#1073#1083#1080#1094#1077#1081
  TextHeight = 21
  object lblCodePage: TLabel [0]
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 489
    Height = 21
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 5
    Align = alTop
    Caption = #1050#1086#1076#1080#1088#1086#1074#1082#1072' '#1089#1086#1079#1076#1072#1074#1072#1077#1084#1086#1075#1086' '#1090#1077#1082#1089#1090#1086#1074#1086#1075#1086' '#1092#1072#1081#1083#1072' *'
    ExplicitWidth = 322
  end
  inherited btnStart: TButton
    ExplicitTop = 214
    ExplicitWidth = 483
  end
  object cbbCodePage: TComboBox [2]
    AlignWithMargins = True
    Left = 10
    Top = 36
    Width = 489
    Height = 29
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 10
    Align = alTop
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 1
    Text = '1251 ANSI Cyrillic; Cyrillic (Windows)'
    Items.Strings = (
      '1251 ANSI Cyrillic; Cyrillic (Windows)'
      '65001 Unicode (UTF-8)'
      '866 OEM Russian; Cyrillic (DOS)'
      '37 IBM EBCDIC US-Canada'
      '437 OEM United States'
      '500 IBM EBCDIC International'
      '708 Arabic (ASMO 708)'
      '709 Arabic (ASMO-449+, BCON V4)'
      '710 Arabic - Transparent Arabic'
      '720 Arabic (Transparent ASMO); Arabic (DOS)'
      '737 OEM Greek (formerly 437G); Greek (DOS)'
      '775 OEM Baltic; Baltic (DOS)'
      '850 OEM Multilingual Latin 1; Western European (DOS)'
      '852 OEM Latin 2; Central European (DOS)'
      '855 OEM Cyrillic (primarily Russian)'
      '857 OEM Turkish; Turkish (DOS)'
      '858 OEM Multilingual Latin 1 + Euro symbol'
      '860 OEM Portuguese; Portuguese (DOS)'
      '861 OEM Icelandic; Icelandic (DOS)'
      '862 OEM Hebrew; Hebrew (DOS)'
      '863 OEM French Canadian; French Canadian (DOS)'
      '864 OEM Arabic; Arabic (864)'
      '865 OEM Nordic; Nordic (DOS)'
      '869 OEM Modern Greek; Greek, Modern (DOS)'
      
        '870 IBM EBCDIC Multilingual/ROECE (Latin 2); IBM EBCDIC Multilin' +
        'gual Latin 2'
      '874 Thai (Windows)'
      '875 IBM EBCDIC Greek Modern'
      '932 ANSI/OEM Japanese; Japanese (Shift-JIS)'
      
        '936 ANSI/OEM Simplified Chinese (PRC, Singapore); Chinese Simpli' +
        'fied (GB2312)'
      '949 ANSI/OEM Korean (Unified Hangul Code)'
      
        '950 ANSI/OEM Traditional Chinese (Taiwan; Hong Kong SAR, PRC); C' +
        'hinese Traditional (Big5)'
      '1026 IBM EBCDIC Turkish (Latin 5)'
      '1047 IBM EBCDIC Latin 1/Open System'
      
        '1140 IBM EBCDIC US-Canada (037 + Euro symbol); IBM EBCDIC (US-Ca' +
        'nada-Euro)'
      
        '1141 IBM EBCDIC Germany (20273 + Euro symbol); IBM EBCDIC (Germa' +
        'ny-Euro)'
      
        '1142 IBM EBCDIC Denmark-Norway (20277 + Euro symbol); IBM EBCDIC' +
        ' (Denmark-Norway-Euro)'
      
        '1143 IBM EBCDIC Finland-Sweden (20278 + Euro symbol); IBM EBCDIC' +
        ' (Finland-Sweden-Euro)'
      
        '1144 IBM EBCDIC Italy (20280 + Euro symbol); IBM EBCDIC (Italy-E' +
        'uro)'
      
        '1145 IBM EBCDIC Latin America-Spain (20284 + Euro symbol); IBM E' +
        'BCDIC (Spain-Euro)'
      
        '1146 IBM EBCDIC United Kingdom (20285 + Euro symbol); IBM EBCDIC' +
        ' (UK-Euro)'
      
        '1147 IBM EBCDIC France (20297 + Euro symbol); IBM EBCDIC (France' +
        '-Euro)'
      
        '1148 IBM EBCDIC International (500 + Euro symbol); IBM EBCDIC (I' +
        'nternational-Euro)'
      
        '1149 IBM EBCDIC Icelandic (20871 + Euro symbol); IBM EBCDIC (Ice' +
        'landic-Euro)'
      
        '1200 Unicode UTF-16, little endian byte order (BMP of ISO 10646)' +
        '; available only to managed applications'
      
        '1201 Unicode UTF-16, big endian byte order; available only to ma' +
        'naged applications'
      '1250 ANSI Central European; Central European (Windows)'
      '1252 ANSI Latin 1; Western European (Windows)'
      '1253 ANSI Greek; Greek (Windows)'
      '1254 ANSI Turkish; Turkish (Windows)'
      '1255 ANSI Hebrew; Hebrew (Windows)'
      '1256 ANSI Arabic; Arabic (Windows)'
      '1257 ANSI Baltic; Baltic (Windows)'
      '1258 ANSI/OEM Vietnamese; Vietnamese (Windows)'
      '1361 Korean (Johab)'
      '10000 MAC Roman; Western European (Mac)'
      '10001 Japanese (Mac)'
      '10002 MAC Traditional Chinese (Big5); Chinese Traditional (Mac)'
      '10003 Korean (Mac)'
      '10004 Arabic (Mac)'
      '10005 Hebrew (Mac)'
      '10006 Greek (Mac)'
      '10007 Cyrillic (Mac)'
      '10008 MAC Simplified Chinese (GB 2312); Chinese Simplified (Mac)'
      '10010 Romanian (Mac)'
      '10017 Ukrainian (Mac)'
      '10021 Thai (Mac)'
      '10029 MAC Latin 2; Central European (Mac)'
      '10079 Icelandic (Mac)'
      '10081 Turkish (Mac)'
      '10082 Croatian (Mac)'
      
        '12000 Unicode UTF-32, little endian byte order; available only t' +
        'o managed applications'
      
        '12001 Unicode UTF-32, big endian byte order; available only to m' +
        'anaged applications'
      '20000 CNS Taiwan; Chinese Traditional (CNS)'
      '20001 TCA Taiwan'
      '20002 Eten Taiwan; Chinese Traditional (Eten)'
      '20003 IBM5550 Taiwan'
      '20004 TeleText Taiwan'
      '20005 Wang Taiwan'
      
        '20105 IA5 (IRV International Alphabet No. 5, 7-bit); Western Eur' +
        'opean (IA5)'
      '20106 IA5 German (7-bit)'
      '20107 IA5 Swedish (7-bit)'
      '20108 IA5 Norwegian (7-bit)'
      '20127 US-ASCII (7-bit)'
      '20261 T.61'
      '20269 ISO 6937 Non-Spacing Accent'
      '20273 IBM EBCDIC Germany'
      '20277 IBM EBCDIC Denmark-Norway'
      '20278 IBM EBCDIC Finland-Sweden'
      '20280 IBM EBCDIC Italy'
      '20284 IBM EBCDIC Latin America-Spain'
      '20285 IBM EBCDIC United Kingdom'
      '20290 IBM EBCDIC Japanese Katakana Extended'
      '20297 IBM EBCDIC France'
      '20420 IBM EBCDIC Arabic'
      '20423 IBM EBCDIC Greek'
      '20424 IBM EBCDIC Hebrew'
      '20833 IBM EBCDIC Korean Extended'
      '20838 IBM EBCDIC Thai'
      '20866 Russian (KOI8-R); Cyrillic (KOI8-R)'
      '20871 IBM EBCDIC Icelandic'
      '20880 IBM EBCDIC Cyrillic Russian'
      '20905 IBM EBCDIC Turkish'
      '20924 IBM EBCDIC Latin 1/Open System (1047 + Euro symbol)'
      '20932 Japanese (JIS 0208-1990 and 0212-1990)'
      
        '20936 Simplified Chinese (GB2312); Chinese Simplified (GB2312-80' +
        ')'
      '20949 Korean Wansung'
      '21025 IBM EBCDIC Cyrillic Serbian-Bulgarian'
      '21027 (deprecated)'
      '21866 Ukrainian (KOI8-U); Cyrillic (KOI8-U)'
      '28591 ISO 8859-1 Latin 1; Western European (ISO)'
      '28592 ISO 8859-2 Central European; Central European (ISO)'
      '28593 ISO 8859-3 Latin 3'
      '28594 ISO 8859-4 Baltic'
      '28595 ISO 8859-5 Cyrillic'
      '28596 ISO 8859-6 Arabic'
      '28597 ISO 8859-7 Greek'
      '28598 ISO 8859-8 Hebrew; Hebrew (ISO-Visual)'
      '28599 ISO 8859-9 Turkish'
      '28603 ISO 8859-13 Estonian'
      '28605 ISO 8859-15 Latin 9'
      '29001 Europa 3'
      '38598 ISO 8859-8 Hebrew; Hebrew (ISO-Logical)'
      
        '50220 ISO 2022 Japanese with no halfwidth Katakana; Japanese (JI' +
        'S)'
      
        '50221 ISO 2022 Japanese with halfwidth Katakana; Japanese (JIS-A' +
        'llow 1 byte Kana)'
      
        '50222 ISO 2022 Japanese JIS X 0201-1989; Japanese (JIS-Allow 1 b' +
        'yte Kana - SO/SI)'
      '50225 ISO 2022 Korean'
      '50227 ISO 2022 Simplified Chinese; Chinese Simplified (ISO 2022)'
      '50229 ISO 2022 Traditional Chinese'
      '50930 EBCDIC Japanese (Katakana) Extended'
      '50931 EBCDIC US-Canada and Japanese'
      '50933 EBCDIC Korean Extended and Korean'
      '50935 EBCDIC Simplified Chinese Extended and Simplified Chinese'
      '50936 EBCDIC Simplified Chinese'
      '50937 EBCDIC US-Canada and Traditional Chinese'
      '50939 EBCDIC Japanese (Latin) Extended and Japanese'
      '51932 EUC Japanese'
      '51936 EUC Simplified Chinese; Chinese Simplified (EUC)'
      '51949 EUC Korean'
      '51950 EUC Traditional Chinese'
      '52936 HZ-GB2312 Simplified Chinese; Chinese Simplified (HZ)'
      
        '54936 Windows XP and later:'#160'GB18030 Simplified Chinese (4 byte);' +
        ' Chinese Simplified (GB18030)'
      '57002 ISCII Devanagari'
      '57003 ISCII Bangla'
      '57004 ISCII Tamil'
      '57005 ISCII Telugu'
      '57006 ISCII Assamese'
      '57007 ISCII Odia'
      '57008 ISCII Kannada'
      '57009 ISCII Malayalam'
      '57010 ISCII Gujarati'
      '57011 ISCII Punjabi'
      '65000 Unicode (UTF-7)')
    ExplicitWidth = 485
  end
  inherited btnCancel: TButton
    TabOrder = 2
  end
end
