object formPedidoView: TformPedidoView
  Left = 0
  Top = 0
  Caption = 'Pedido de vendas'
  ClientHeight = 482
  ClientWidth = 1050
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object panelRodaPe: TPanel
    Left = 0
    Top = 456
    Width = 1050
    Height = 26
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object labelValorTotal: TLabel
      Left = 888
      Top = 4
      Width = 69
      Height = 13
      Caption = 'Valor total: R$'
    end
    object labelValorTotalPedido: TLabel
      Left = 963
      Top = 4
      Width = 22
      Height = 13
      Caption = '0,00'
    end
    object buttonFechar: TButton
      Left = 440
      Top = 2
      Width = 215
      Height = 21
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = buttonFecharClick
    end
  end
  object panelCampos: TPanel
    Left = 0
    Top = 0
    Width = 215
    Height = 456
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object labelCliente: TLabel
      Left = 8
      Top = 168
      Width = 37
      Height = 13
      Caption = 'Cliente:'
    end
    object labelProduto: TLabel
      Left = 8
      Top = 11
      Width = 42
      Height = 13
      Caption = 'Produto:'
    end
    object labelQuantidade: TLabel
      Left = 8
      Top = 62
      Width = 60
      Height = 13
      Caption = 'Quantidade:'
    end
    object Label1: TLabel
      Left = 8
      Top = 89
      Width = 67
      Height = 13
      Caption = 'Valor unit'#225'rio:'
    end
    object labelNomeProduto: TLabel
      Left = 8
      Top = 35
      Width = 72
      Height = 13
      Caption = 'Nome produto:'
    end
    object editCliente: TEdit
      Left = 88
      Top = 165
      Width = 121
      Height = 21
      TabOrder = 5
      OnChange = editClienteChange
    end
    object editProduto: TEdit
      Left = 88
      Top = 8
      Width = 57
      Height = 21
      TabOrder = 0
      OnChange = editProdutoChange
    end
    object editQuantidade: TEdit
      Left = 88
      Top = 59
      Width = 89
      Height = 21
      TabOrder = 1
    end
    object editValorUnitario: TEdit
      Left = 88
      Top = 86
      Width = 89
      Height = 21
      TabOrder = 2
    end
    object buttonConfirmar: TButton
      Left = 127
      Top = 125
      Width = 75
      Height = 25
      Caption = 'Confirmar'
      TabOrder = 3
      OnClick = buttonConfirmarClick
    end
    object buttonLimpar: TButton
      Left = 8
      Top = 125
      Width = 75
      Height = 25
      Caption = 'Limpar'
      TabOrder = 4
      TabStop = False
      OnClick = buttonLimparClick
    end
    object buttonGravarPedido: TButton
      Left = 8
      Top = 205
      Width = 201
      Height = 25
      Caption = 'Gravar pedido'
      TabOrder = 6
      OnClick = buttonGravarPedidoClick
    end
    object panelCarregarPedido: TPanel
      Left = 0
      Top = 360
      Width = 216
      Height = 96
      BevelOuter = bvNone
      TabOrder = 7
      object labelNumeroPedido: TLabel
        Left = 8
        Top = 23
        Width = 76
        Height = 13
        Caption = 'N'#250'mero pedido:'
      end
      object editNumeroPedido: TEdit
        Left = 88
        Top = 15
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object buttonCancelarPedido: TButton
        Left = 8
        Top = 51
        Width = 89
        Height = 25
        Caption = 'Cancelar pedido'
        TabOrder = 2
        OnClick = buttonCancelarPedidoClick
      end
      object buutonCarregarPedido: TButton
        Left = 112
        Top = 51
        Width = 90
        Height = 25
        Caption = 'Carregar pedido'
        TabOrder = 1
        OnClick = buutonCarregarPedidoClick
      end
    end
    object editNomeProduto: TEdit
      Left = 88
      Top = 32
      Width = 121
      Height = 21
      TabStop = False
      ParentColor = True
      ReadOnly = True
      TabOrder = 8
    end
  end
  object Panel2: TPanel
    Left = 215
    Top = 0
    Width = 835
    Height = 456
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnaelGrid'
    TabOrder = 2
    object DBGridListagemPedido: TDBGrid
      Left = 0
      Top = 0
      Width = 835
      Height = 456
      Align = alClient
      DataSource = DataSource
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyDown = DBGridListagemPedidoKeyDown
    end
  end
  object FDMemTable: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'id'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'codigo_produto'
        DataType = ftInteger
      end
      item
        Name = 'descricao_produto'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'quantidade'
        DataType = ftCurrency
        Precision = 19
      end
      item
        Name = 'valor_unitario'
        DataType = ftCurrency
        Precision = 19
      end
      item
        Name = 'valor_total'
        DataType = ftCurrency
        Precision = 19
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 1000
    Top = 56
    object FDMemTableid: TStringField
      FieldName = 'id'
      Visible = False
    end
    object FDMemTableCódigodoproduto: TIntegerField
      DisplayLabel = 'C'#243'digo do produto'
      DisplayWidth = 16
      FieldName = 'codigo_produto'
    end
    object FDMemTabledescricao_produto: TStringField
      DisplayLabel = 'Descri'#231#227'o do produto'
      DisplayWidth = 62
      FieldName = 'descricao_produto'
      Size = 100
    end
    object FDMemTablequantidade: TCurrencyField
      DisplayLabel = 'Quantidade'
      DisplayWidth = 12
      FieldName = 'quantidade'
    end
    object FDMemTablevalor_unitario: TCurrencyField
      DisplayLabel = 'Valor unit'#225'rio'
      DisplayWidth = 15
      FieldName = 'valor_unitario'
    end
    object FDMemTablevalot_total: TCurrencyField
      DisplayLabel = 'Valor toral'
      DisplayWidth = 13
      FieldName = 'valor_total'
    end
  end
  object DataSource: TDataSource
    DataSet = FDMemTable
    Left = 1000
    Top = 8
  end
end
