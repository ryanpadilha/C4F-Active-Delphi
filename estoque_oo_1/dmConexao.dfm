object Conexao: TConexao
  OldCreateOrder = False
  Left = 206
  Top = 191
  Height = 251
  Width = 517
  object ZConnection: TZConnection
    Protocol = 'postgresql-7'
    HostName = 'localhost'
    Port = 5432
    Database = 'ActiveDelphi'
    User = 'postgres'
    Password = 'postdba'
    Left = 35
    Top = 35
  end
  object QryCRUD: TZQuery
    Connection = ZConnection
    Params = <>
    Left = 125
    Top = 30
  end
  object QryGetObject: TZQuery
    Connection = ZConnection
    Params = <>
    Left = 200
    Top = 30
  end
  object QryGeral: TZQuery
    Connection = ZConnection
    Params = <>
    Left = 270
    Top = 30
  end
end
