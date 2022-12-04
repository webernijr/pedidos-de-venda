object dmWK: TdmWK
  OldCreateOrder = False
  Height = 259
  Width = 450
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=teste'
      'User_Name=root'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object MySQLDriverLink: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Weber\pedidos-de-venda\Output\libmysql.dll'
    Left = 200
    Top = 16
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 344
    Top = 16
  end
end
