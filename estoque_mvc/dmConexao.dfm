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
  object QryProduto: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      'SELECT * FROM PRODUTO')
    Params = <>
    Left = 105
    Top = 100
    object QryProdutopro_codigo: TIntegerField
      FieldName = 'pro_codigo'
      Required = True
    end
    object QryProdutopro_status: TBooleanField
      FieldName = 'pro_status'
    end
    object QryProdutopro_descricao: TStringField
      FieldName = 'pro_descricao'
      Size = 200
    end
    object QryProdutopro_desc_reduzido: TStringField
      FieldName = 'pro_desc_reduzido'
      Size = 50
    end
    object QryProdutomar_codigo: TIntegerField
      FieldName = 'mar_codigo'
    end
    object QryProdutound_codigo: TIntegerField
      FieldName = 'und_codigo'
    end
    object QryProdutopro_c_principal: TStringField
      FieldName = 'pro_c_principal'
    end
  end
  object QryEstoque: TZQuery
    Connection = ZConnection
    SQL.Strings = (
      'SELECT * FROM ESTOQUE')
    Params = <>
    Left = 170
    Top = 100
    object QryEstoqueest_codigo: TIntegerField
      FieldName = 'est_codigo'
      Required = True
    end
    object QryEstoquepro_codigo: TIntegerField
      FieldName = 'pro_codigo'
      Required = True
    end
    object QryEstoqueest_data: TDateField
      FieldName = 'est_data'
      Required = True
    end
    object QryEstoqueest_hora: TTimeField
      FieldName = 'est_hora'
      Required = True
    end
    object QryEstoqueest_documento: TStringField
      FieldName = 'est_documento'
    end
    object QryEstoqueest_saldo: TFloatField
      FieldName = 'est_saldo'
      DisplayFormat = '###,##0.000'
    end
    object QryEstoqueest_vlr_custo: TFloatField
      FieldName = 'est_vlr_custo'
      DisplayFormat = '###,##0.000'
    end
    object QryEstoqueest_tipo_mov: TStringField
      FieldName = 'est_tipo_mov'
      Size = 1
    end
    object QryEstoqueest_quantidade: TFloatField
      FieldName = 'est_quantidade'
      DisplayFormat = '###,##0.000'
    end
    object QryEstoqueest_flag: TBooleanField
      FieldName = 'est_flag'
    end
    object QryEstoqueemp_codigo: TIntegerField
      FieldName = 'emp_codigo'
      Required = True
    end
  end
  object dsProduto: TDataSource
    DataSet = QryProduto
    Left = 105
    Top = 150
  end
  object dsEstoque: TDataSource
    DataSet = QryEstoque
    Left = 175
    Top = 150
  end
end
