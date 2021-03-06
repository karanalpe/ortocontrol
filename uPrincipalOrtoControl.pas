unit uPrincipalOrtoControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, uFramePadrao, ExtCtrls, Buttons, ZConnection, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, StdCtrls, ppBands,
  ppCache, ppClass, ppProd, ppReport, ppComm, ppRelatv, ppDB, ppDBPipe, ShellAPI;

type
  TfrmPrincipalOrtoControl = class(TForm)
    MainMenu1: TMainMenu;
    Cliente1: TMenuItem;
    Cliente2: TMenuItem;
    Sobre1: TMenuItem;
    Sobre2: TMenuItem;
    frmPadraoFrame1: TfrmPadraoFrame;
    ZConnection1: TZConnection;
    qrySqlCliente: TZQuery;
    dsSql: TDataSource;
    qrySqlControle: TZQuery;
    qrySqlControleCdigo: TIntegerField;
    qrySqlControleDtEntrada: TDateField;
    qrySqlControleCliente: TStringField;
    qrySqlControlePaciente: TStringField;
    qrySqlControleAparelho: TStringField;
    qrySqlControleQtdMod: TStringField;
    qrySqlControleStatus: TStringField;
    qrySqlControleDtSada: TDateField;
    Sobre3: TMenuItem;
    qrySqlClienteCdigo: TIntegerField;
    qrySqlClienteCliente: TStringField;
    qrySqlClienteEndereo: TStringField;
    qrySqlClienteNmero: TStringField;
    qrySqlClienteComplemento: TStringField;
    qrySqlClienteBairro: TStringField;
    qrySqlClienteCidade: TStringField;
    qrySqlClienteUF: TStringField;
    qrySqlClienteCep: TStringField;
    qrySqlClienteCpfCnpj: TStringField;
    qrySqlClienteRgIe: TStringField;
    qrySqlClienteObs: TStringField;
    qrySqlClienteTelefone: TStringField;
    qrySqlClienteCelular: TStringField;
    qrySqlClienteEmail: TStringField;
    qryExcluir: TZQuery;
    qrySqlControleCod_Cli: TIntegerField;
    procedure frmPadraoFrame1Timer1Timer(Sender: TObject);
    procedure Cliente1Click(Sender: TObject);
    procedure frmPadraoFrame1SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Cliente2Click(Sender: TObject);
    procedure frmPadraoFrame1SpeedButton2Click(Sender: TObject);
    procedure frmPadraoFrame1edtPesquisaChange(Sender: TObject);
    procedure frmPadraoFrame1SpeedButton4Click(Sender: TObject);
    procedure frmPadraoFrame1DBGrid1DblClick(Sender: TObject);
    procedure frmPadraoFrame1edtPesquisaKeyPress(Sender: TObject;
      var Key: Char);
    procedure frmPadraoFrame1SpeedButton3Click(Sender: TObject);
    procedure Sobre3Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure Sobre2Click(Sender: TObject);
  private
    { Private declarations }
    Procedure ChamadaFrameCliente;
    Procedure CarregarDadosCliente;
    Procedure CarregaDadosControle;
  public
    { Public declarations }
    Procedure ChamadaFrameControle;
  end;

var
  frmPrincipalOrtoControl: TfrmPrincipalOrtoControl;
  sCodigo, sCliente, sEndereco, sNumero, sComplemento, sBairro, sCidade, sUf, sCep, sCpf, sRg, sObs, sTelefone, sCelular, sEmail, sDtEntrada, sPaciente, sAparelho, sQtdModelo, sStatus, sDtSaida, sCodigoCli : String;
  iCodigoCliente : integer;
implementation
uses uCadastroCliente, uCadastroControleOrtodontico, uPesquisaControle, uSobre, uRelatorioControle;
{$R *.dfm}

procedure TfrmPrincipalOrtoControl.frmPadraoFrame1Timer1Timer(
  Sender: TObject);
begin
  frmPadraoFrame1.Timer1Timer(Sender);

end;

procedure TfrmPrincipalOrtoControl.Cliente1Click(Sender: TObject);
begin
  iCodigoCliente := 0;
  frmPadraoFrame1.edtPesquisa.Clear;
  frmPadraoFrame1.edtPesquisa.SetFocus;
  ChamadaFrameControle;
end;

procedure TfrmPrincipalOrtoControl.frmPadraoFrame1SpeedButton1Click(
  Sender: TObject);
begin

  if frmPadraoFrame1.lblTitulo.Caption = 'Controle Ortod�ntico' then
  begin
    frmCadastroControleOrtodontico := TfrmCadastroControleOrtodontico.Create(Application);
    uCadastroControleOrtodontico.iTipoOperacao := 1;// 1- Inclus�o
    frmCadastroControleOrtodontico.ShowModal;
    frmCadastroControleOrtodontico.Free;
  end;

  if frmPadraoFrame1.lblTitulo.Caption = 'Cadastro de Cliente' then
  begin
    frmCadastroCliente := TfrmCadastroCliente.Create(Application);
    uCadastroCliente.iTipoOperacao := 1;// 1- Inclus�o
    frmCadastroCliente.ShowModal;
    frmCadastroCliente.Free;
  end;

end;

procedure TfrmPrincipalOrtoControl.ChamadaFrameControle;
begin

    frmPadraoFrame1.Image3.Visible := true;
    frmPadraoFrame1.Image1.Visible := false;

    frmPadraoFrame1.lblTitulo.Caption:= 'Controle Ortod�ntico';
    with qrySqlControle do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select c.i_cod_controle "C�digo",                       ');
      SQL.Add('       c.dt_entrada_controle "Dt Entrada",              ');
      SQL.Add('       c.i_cod_cliente "Cod_Cli",                       ');
      SQL.Add('       cl.s_nome_cliente "Cliente",                     ');
      SQL.Add('       c.s_nome_paciente_controle "Paciente",           ');
      SQL.Add('       c.s_descricao_aparelho_controle "Aparelho",      ');
      SQL.Add('       c.s_qtd_modelo_controle "Qtd Mod",               ');
      SQL.Add('       c.s_status_controle "Status",                    ');
      SQL.Add('       c.dt_saida_controle "Dt Sa�da"                   ');
      SQL.Add('from controle c                                         ');
      SQL.Add('     inner join cliente cl                              ');
      SQL.Add('       on (c.i_cod_cliente = cl.i_cod_cliente)          ');

      if iCodigoCliente <> 0 then
      SQL.Add('where c.i_cod_controle = ' + IntToStr(iCodigoCliente)    );
      
      SQL.Add('order by (c.i_cod_controle) desc                        ');
    end;

      dsSql.DataSet := qrySqlControle;
      qrySqlControle.Open;
end;

procedure TfrmPrincipalOrtoControl.FormShow(Sender: TObject);
begin
  iCodigoCliente := 0;
  frmPadraoFrame1.edtPesquisa.SetFocus;
  ChamadaFrameControle;
end;

procedure TfrmPrincipalOrtoControl.ChamadaFrameCliente;
begin

    frmPadraoFrame1.Image3.Visible := false;
    frmPadraoFrame1.Image1.Visible := true;


    frmPadraoFrame1.lblTitulo.Caption:= 'Cadastro de Cliente';
    qrySqlCliente.Close;
    qrySqlCliente.SQL.Clear;

    qrySqlCliente.SQL.Add('select cl.i_cod_cliente "C�digo",                        ');

    qrySqlCliente.SQL.Add('       cl.s_nome_cliente "Cliente",                      ');
    qrySqlCliente.SQL.Add('       cl.s_endereco_cliente "Endere�o",                 ');
    qrySqlCliente.SQL.Add('       cl.s_num_cliente "N�mero",                        ');
    qrySqlCliente.SQL.Add('       cl.s_complemento_cliente "Complemento",           ');
    qrySqlCliente.SQL.Add('       cl.s_bairro_cliente "Bairro",                     ');
    qrySqlCliente.SQL.Add('       cl.s_cidade_cliente "Cidade",                     ');
    qrySqlCliente.SQL.Add('       cl.s_uf_cliente "UF",                             ');
    qrySqlCliente.SQL.Add('       cl.s_cep_cliente "Cep",                           ');
    qrySqlCliente.SQL.Add('       cl.s_cpf_cnpj_cliente "Cpf/Cnpj",                 ');
    qrySqlCliente.SQL.Add('       cl.s_rg_ie_cliente "Rg / Ie",                     ');
    qrySqlCliente.SQL.Add('       cl.s_observacao_cliente "Obs",                    ');
    qrySqlCliente.SQL.Add('       cl.s_telefone_cliente "Telefone",                 ');
    qrySqlCliente.SQL.Add('       cl.s_celular_cliente "Celular",                   ');
    qrySqlCliente.SQL.Add('       cl.s_email_cliente "E-mail"                       ');
    qrySqlCliente.SQL.Add('from cliente cl                                          ');
    qrySqlCliente.SQL.Add('order by cl.i_cod_cliente                               ');

    dsSql.DataSet := qrySqlCliente;
    qrySqlCliente.Open;

end;

procedure TfrmPrincipalOrtoControl.Cliente2Click(Sender: TObject);
begin

  qrySqlControle.Close;
  frmPadraoFrame1.edtPesquisa.Clear;
  frmPadraoFrame1.edtPesquisa.SetFocus;
  ChamadaFrameCliente;


end;

procedure TfrmPrincipalOrtoControl.frmPadraoFrame1SpeedButton2Click(
  Sender: TObject);
begin

  if frmPadraoFrame1.lblTitulo.Caption = 'Controle Ortod�ntico' then
  begin
    case MessageDlg('Tem certeza que deseja excluir esse controle? ' + #13 + 'Ap�s a exclus�o, ser� imposs�vel retornar a a��o.', mtWarning, mbOKCancel, 1) of
    mrOk : begin
             try
              CarregaDadosControle;
              qryExcluir.close;
              qryExcluir.SQL.Clear;
              qryExcluir.SQL.Add('delete from controle c               ');
              qryExcluir.SQL.Add('where c.i_cod_controle = ' + sCodigo);
              qryExcluir.ExecSQL;
              qrySqlControle.Close;
              qrySqlControle.Open;              
             except
              MessageDlg('Erro inesperado, consulte o respons�vel', mtError, [mbOK], 1)
             end;
           end;
    end;
  end;

  if frmPadraoFrame1.lblTitulo.Caption = 'Cadastro de Cliente' then
  begin

    CarregarDadosCliente;
    case MessageDlg('Tem certeza que deseja excluir o cliente: ' + sCliente, mtWarning, mbOKCancel, 1) of
    mrOk : begin
             try
              qryExcluir.close;
              qryExcluir.SQL.Clear;
              qryExcluir.SQL.Add('delete from cliente cl              ');
              qryExcluir.SQL.Add('where cl.i_cod_cliente = ' + sCodigo);
              qryExcluir.ExecSQL;
             except
              MessageDlg('Imposs�vel excluir esse cliente, existe movimenta��o para ele!', mtError, [mbOK], 1)
             end;
           end;
    end;
    qrySqlCliente.Close;
    qrySqlCliente.Open;
  end;
end;

procedure TfrmPrincipalOrtoControl.frmPadraoFrame1edtPesquisaChange(
  Sender: TObject);
begin

  if frmPadraoFrame1.lblTitulo.Caption = 'Controle Ortod�ntico' then
  begin
    with qrySqlControle do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select c.i_cod_controle "C�digo",                       ');
      SQL.Add('       c.dt_entrada_controle "Dt Entrada",              ');
      SQL.Add('       c.i_cod_cliente "Cod_Cli",                       ');
      SQL.Add('       cl.s_nome_cliente "Cliente",                     ');
      SQL.Add('       c.s_nome_paciente_controle "Paciente",           ');
      SQL.Add('       c.s_descricao_aparelho_controle "Aparelho",      ');
      SQL.Add('       c.s_qtd_modelo_controle "Qtd Mod",               ');
      SQL.Add('       c.s_status_controle "Status",                    ');
      SQL.Add('       c.dt_saida_controle "Dt Sa�da"                   ');
      SQL.Add('from controle c                                         ');
      SQL.Add('     inner join cliente cl                              ');
      SQL.Add('       on (c.i_cod_cliente = cl.i_cod_cliente)          ');
      SQL.Add('where cl.s_nome_cliente like ' + QuotedStr('%' + frmPadraoFrame1.edtPesquisa.Text + '%') );

      SQL.Add('order by (c.i_cod_controle) desc                        ');

    end;

      dsSql.DataSet := qrySqlControle;
      qrySqlControle.Open;

  end;

  if frmPadraoFrame1.lblTitulo.Caption = 'Cadastro de Cliente' then
  begin
    qrySqlCliente.Close;
    qrySqlCliente.SQL.Clear;
    qrySqlCliente.SQL.Add('select cl.i_cod_cliente "C�digo",                        ');
    qrySqlCliente.SQL.Add('       cl.s_nome_cliente "Cliente",                      ');
    qrySqlCliente.SQL.Add('       cl.s_endereco_cliente "Endere�o",                 ');
    qrySqlCliente.SQL.Add('       cl.s_num_cliente "N�mero",                        ');
    qrySqlCliente.SQL.Add('       cl.s_complemento_cliente "Complemento",           ');
    qrySqlCliente.SQL.Add('       cl.s_bairro_cliente "Bairro",                     ');
    qrySqlCliente.SQL.Add('       cl.s_cidade_cliente "Cidade",                     ');
    qrySqlCliente.SQL.Add('       cl.s_uf_cliente "UF",                             ');
    qrySqlCliente.SQL.Add('       cl.s_cep_cliente "Cep",                           ');
    qrySqlCliente.SQL.Add('       cl.s_cpf_cnpj_cliente "Cpf/Cnpj",                 ');
    qrySqlCliente.SQL.Add('       cl.s_rg_ie_cliente "Rg / Ie",                     ');
    qrySqlCliente.SQL.Add('       cl.s_observacao_cliente "Obs",                    ');
    qrySqlCliente.SQL.Add('       cl.s_telefone_cliente "Telefone",                 ');
    qrySqlCliente.SQL.Add('       cl.s_celular_cliente "Celular",                   ');
    qrySqlCliente.SQL.Add('       cl.s_email_cliente "E-mail"                       ');
    qrySqlCliente.SQL.Add('from cliente cl                                          ');
    qrySqlCliente.SQL.Add('where cl.s_nome_cliente like ' + QuotedStr('%' + frmPadraoFrame1.edtPesquisa.Text + '%') );
    qrySqlCliente.Open;
  end;

  if frmPadraoFrame1.lblTitulo.Caption = 'Cadastro de Cliente' then
  begin
    with qrySqlControle do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select c.i_cod_controle "C�digo",                       ');
      SQL.Add('       c.dt_entrada_controle "Dt Entrada",              ');
      SQL.Add('       cl.s_nome_cliente "Cliente",                     ');
      SQL.Add('       c.s_nome_paciente_controle "Paciente",           ');
      SQL.Add('       c.s_descricao_aparelho_controle "Aparelho",      ');
      SQL.Add('       c.s_qtd_modelo_controle "Qtd Mod",               ');
      SQL.Add('       c.s_status_controle "Status",                    ');
      SQL.Add('       c.dt_saida_controle "Dt Sa�da"                   ');
      SQL.Add('from controle c                                         ');
      SQL.Add('     inner join cliente cl                              ');
      SQL.Add('       on (c.i_cod_cliente = cl.i_cod_cliente)          ');

      if iCodigoCliente <> 0 then
      SQL.Add('where c.i_cod_controle = ' + IntToStr(iCodigoCliente)    );

      SQL.Add('order by (c.i_cod_controle) desc                        ');
    end;
  end;


end;

procedure TfrmPrincipalOrtoControl.CarregarDadosCliente;
begin

  sCodigo := qrySqlCliente.FieldByName('C�digo').AsString;
  sCliente := qrySqlCliente.FieldByName('Cliente').AsString;
  sEndereco := qrySqlCliente.FieldByName('Endere�o').AsString;
  sNumero := qrySqlCliente.FieldByName('N�mero').AsString;
  sComplemento := qrySqlCliente.FieldByName('Complemento').AsString;
  sBairro := qrySqlCliente.FieldByName('Bairro').AsString;
  sCidade := qrySqlCliente.FieldByName('Cidade').AsString;
  sUf := qrySqlCliente.FieldByName('UF').AsString;
  sCep := qrySqlCliente.FieldByName('Cep').AsString;
  sCpf := qrySqlCliente.FieldByName('Cpf/Cnpj').AsString;
  sRg := qrySqlCliente.FieldByName('Rg / Ie').AsString;
  sObs := qrySqlCliente.FieldByName('Obs').AsString;
  sTelefone := qrySqlCliente.FieldByName('Telefone').AsString;
  sCelular := qrySqlCliente.FieldByName('Celular').AsString;
  sEmail := qrySqlCliente.FieldByName('E-mail').AsString;
  
end;

procedure TfrmPrincipalOrtoControl.frmPadraoFrame1SpeedButton4Click(
  Sender: TObject);
begin

  if frmPadraoFrame1.lblTitulo.Caption = 'Controle Ortod�ntico' then
  begin
    CarregaDadosControle;
    frmCadastroControleOrtodontico := TfrmCadastroControleOrtodontico.Create(Application);
    uCadastroControleOrtodontico.iTipoOperacao := 2; //2 - Edi��o
    frmCadastroControleOrtodontico.ShowModal;
    frmCadastroControleOrtodontico.Free;
  end;

  if frmPadraoFrame1.lblTitulo.Caption = 'Cadastro de Cliente' then
  begin
    CarregarDadosCliente;
    frmCadastroCliente := TfrmCadastroCliente.Create(Application);
    uCadastroCliente.iTipoOperacao := 2; //2 - Edi��o
    frmCadastroCliente.ShowModal;
    frmCadastroCliente.Free;
  end;



end;

procedure TfrmPrincipalOrtoControl.frmPadraoFrame1DBGrid1DblClick(
  Sender: TObject);
begin
  frmPadraoFrame1.sbEditar.Click;
end;

procedure TfrmPrincipalOrtoControl.frmPadraoFrame1edtPesquisaKeyPress(
  Sender: TObject; var Key: Char);
begin
  if key = #13 then
  frmPadraoFrame1.DBGrid1.SetFocus;
end;


procedure TfrmPrincipalOrtoControl.frmPadraoFrame1SpeedButton3Click(
  Sender: TObject);
begin
  if frmPadraoFrame1.lblTitulo.Caption = 'Controle Ortod�ntico' then
  begin
    frmPesquisaControle := TfrmPesquisaControle.Create(Application);
    frmPesquisaControle.ShowModal;
    frmPesquisaControle.Free;
  end;

end;

procedure TfrmPrincipalOrtoControl.CarregaDadosControle;
begin

  sCodigo := qrySqlControle.FieldByName('C�digo').AsString;
  sDtEntrada := qrySqlControle.FieldByName('Dt Entrada').AsString;
  sPaciente := qrySqlControle.FieldByName('Paciente').AsString;
  sCodigoCli := qrySqlControle.FieldByName('Cod_Cli').AsString;
  sCliente := qrySqlControle.FieldByName('Cliente').AsString;
  sAparelho := qrySqlControle.FieldByName('Aparelho').AsString;
  sQtdModelo := qrySqlControle.FieldByName('Qtd Mod').AsString;
  sStatus := qrySqlControle.FieldByName('Status').AsString;
  sDtSaida := qrySqlControle.FieldByName('Dt Sa�da').AsString;
  
end;

procedure TfrmPrincipalOrtoControl.Sobre3Click(Sender: TObject);
begin
  frmSobre := TfrmSobre.Create(Application);
  frmSobre.ShowModal;
  frmSobre.Free;
end;

procedure TfrmPrincipalOrtoControl.Sobre1Click(Sender: TObject);
begin
  frmRelatorioControle := TfrmRelatorioControle.Create(Application);
  frmRelatorioControle.ShowModal;
  frmRelatorioControle.Free;
end;

procedure TfrmPrincipalOrtoControl.Sobre2Click(Sender: TObject);
begin

  MessageDlg('Salve esse backup em um pen drive ou em algum E-mail!' + #13 +
             'Caso ocorra qualquer problema com o computador � atrav�s ' + #13 +
              'desse arquivo que conseguiremos recuperar os dados.', mtWarning, [mbOK], 1);

  WinExec('C:\OrtoControl\rotina_backup.bat', SW_NORMAL );
  ShellExecute(Application.HANDLE, 'open', PChar(ExtractFilePath('C:\OrtoControl\Backup\')),nil,nil,SW_SHOWMAXIMIZED);

end;

end.
