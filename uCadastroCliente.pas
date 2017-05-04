unit uCadastroCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uCadastroPadrao, StdCtrls, Buttons, ExtCtrls, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, jpeg;

type
  TfrmCadastroCliente = class(TfrmCadastroPadrao)
    Label2: TLabel;
    edtNome: TEdit;
    Label3: TLabel;
    edtEndereco: TEdit;
    Label4: TLabel;
    edtNumero: TEdit;
    edtComplemento: TEdit;
    Label5: TLabel;
    edtBairro: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edtCidade: TEdit;
    edtUf: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    edtCep: TEdit;
    edtCpf: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    edtRg: TEdit;
    Label15: TLabel;
    menObservacao: TMemo;
    gpContato: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    edtTelefone: TEdit;
    edtCelular: TEdit;
    edtEmail: TEdit;
    qryConsultaUltimaCodigoMax: TLargeintField;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastroCliente: TfrmCadastroCliente;
  iTipoOperacao : integer; // 1- Inclus�o ~ 2- Edi��o

implementation
uses uPrincipalOrtoControl;
{$R *.dfm}

procedure TfrmCadastroCliente.BitBtn1Click(Sender: TObject);
begin
  inherited;

  if iTipoOperacao = 1 then  //Inclus�o
  begin
    with qryPadrao do
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO CLIENTE (I_COD_CLIENTE, S_NOME_CLIENTE, S_ENDERECO_CLIENTE, S_NUM_CLIENTE, S_COMPLEMENTO_CLIENTE,                                  ');
      SQL.Add('                     S_BAIRRO_CLIENTE, S_CIDADE_CLIENTE, S_UF_CLIENTE, S_CEP_CLIENTE, S_CPF_CNPJ_CLIENTE, S_RG_IE_CLIENTE,                     ');
      SQL.Add('                     S_OBSERVACAO_CLIENTE, S_TELEFONE_CLIENTE, S_CELULAR_CLIENTE, S_EMAIL_CLIENTE)                                             ');
      SQL.Add('             VALUES (:P_I_COD_CLIENTE, :P_S_NOME_CLIENTE, :P_S_ENDERECO_CLIENTE, :P_S_NUM_CLIENTE, :P_S_COMPLEMENTO_CLIENTE,                   ');
      SQL.Add('                     :P_S_BAIRRO_CLIENTE, :P_S_CIDADE_CLIENTE, :P_S_UF_CLIENTE, :P_S_CEP_CLIENTE, :P_S_CPF_CNPJ_CLIENTE, :P_S_RG_IE_CLIENTE,   ');
      SQL.Add('                     :P_S_OBSERVACAO_CLIENTE, :P_S_TELEFONE_CLIENTE, :P_S_CELULAR_CLIENTE, :P_S_EMAIL_CLIENTE)                                 ');

      ParamByName('P_I_COD_CLIENTE').AsInteger := 0;
      ParamByName('P_S_NOME_CLIENTE').AsString := edtNome.Text;
      ParamByName('P_S_ENDERECO_CLIENTE').AsString := edtEndereco.Text;
      ParamByName('P_S_NUM_CLIENTE').AsString := edtNumero.Text;
      ParamByName('P_S_COMPLEMENTO_CLIENTE').AsString := edtComplemento.Text;
      ParamByName('P_S_BAIRRO_CLIENTE').AsString := edtBairro.Text;
      ParamByName('P_S_CIDADE_CLIENTE').AsString := edtCidade.Text;
      ParamByName('P_S_UF_CLIENTE').AsString := edtUf.Text;
      ParamByName('P_S_CEP_CLIENTE').AsString := edtCep.Text;
      ParamByName('P_S_CPF_CNPJ_CLIENTE').AsString := edtCpf.Text;
      ParamByName('P_S_RG_IE_CLIENTE').AsString := edtRg.Text;
      ParamByName('P_S_OBSERVACAO_CLIENTE').AsString := menObservacao.Text;
      ParamByName('P_S_TELEFONE_CLIENTE').AsString := edtTelefone.Text;
      ParamByName('P_S_CELULAR_CLIENTE').AsString := edtCelular.Text;
      ParamByName('P_S_EMAIL_CLIENTE').AsString := edtEmail.Text;
      ExecSQL;
    end;
  end;

  if iTipoOperacao = 2 then  //Edi��o
  begin
    with qryPadrao do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE CLIENTE SET S_NOME_CLIENTE = ' + QuotedStr(edtNome.Text)                      + ' ,');
      SQL.Add('                   S_ENDERECO_CLIENTE = ' + QuotedStr(edtEndereco.Text)              + ' ,');
      SQL.Add('                   S_NUM_CLIENTE = ' + QuotedStr(edtNumero.Text)                     + ' ,');
      SQL.Add('                   S_COMPLEMENTO_CLIENTE = ' + QuotedStr(edtComplemento.Text)        + ' ,');
      SQL.Add('                   S_BAIRRO_CLIENTE = ' + QuotedStr(edtBairro.Text)                  + ' ,');
      SQL.Add('                   S_CIDADE_CLIENTE = ' + QuotedStr(edtCidade.Text)                  + ' ,');
      SQL.Add('                   S_UF_CLIENTE = ' + QuotedStr(edtUf.Text)                          + ' ,');
      SQL.Add('                   S_CEP_CLIENTE = ' + QuotedStr(edtCep.Text)                        + ' ,');
      SQL.Add('                   S_CPF_CNPJ_CLIENTE = ' + QuotedStr(edtCpf.Text)                   + ' ,');
      SQL.Add('                   S_RG_IE_CLIENTE = ' + QuotedStr(edtRg.Text)                       + ' ,');
      SQL.Add('                   S_OBSERVACAO_CLIENTE = ' + QuotedStr(menObservacao.Text)          + ' ,');
      SQL.Add('                   S_TELEFONE_CLIENTE = ' + QuotedStr(edtTelefone.Text)              + ' ,');
      SQL.Add('                   S_CELULAR_CLIENTE = ' + QuotedStr(edtCelular.Text)                + ' ,');
      SQL.Add('                   S_EMAIL_CLIENTE = ' + QuotedStr(edtEmail.Text)                          );
      SQL.Add('WHERE I_COD_CLIENTE = ' + edtCodigo.Text                                                   );
      ExecSQL;
    end;
  end;


      frmPrincipalOrtoControl.qrySqlCliente.Close;
      frmPrincipalOrtoControl.qrySqlCliente.Open;
      close;
end;

procedure TfrmCadastroCliente.FormShow(Sender: TObject);
begin
  inherited;

  if iTipoOperacao = 1 then  //Inclus�o
  begin
    qryConsultaUltimaCodigo.Close;
    qryConsultaUltimaCodigo.SQL.Clear;
    qryConsultaUltimaCodigo.SQL.Add('select max(cl.i_cod_cliente) +1 "Max" ');
    qryConsultaUltimaCodigo.SQL.Add('from cliente cl                       ');
    qryConsultaUltimaCodigo.Open;
    edtCodigo.Text := IntToStr( qryConsultaUltimaCodigo.FieldByName('Max').AsInteger );
  end;

  if iTipoOperacao = 2 then   //Edi��o
  begin
    edtCodigo.Text := uPrincipalOrtoControl.sCodigo;
    edtNome.Text := uPrincipalOrtoControl.sCliente;
    edtEndereco.Text := uPrincipalOrtoControl.sEndereco;
    edtNumero.Text := uPrincipalOrtoControl.sNumero;
    edtComplemento.Text := uPrincipalOrtoControl.sComplemento;
    edtBairro.Text := uPrincipalOrtoControl.sBairro;
    edtCidade.Text := uPrincipalOrtoControl.sCidade;
    edtUf.Text := uPrincipalOrtoControl.sUf;
    edtCep.Text := uPrincipalOrtoControl.sCep;
    edtCpf.Text := uPrincipalOrtoControl.sCpf;
    edtRg.Text := uPrincipalOrtoControl.sRg;
    menObservacao.Text := uPrincipalOrtoControl.sObs;
    edtTelefone.Text := uPrincipalOrtoControl.sTelefone;
    edtCelular.Text := uPrincipalOrtoControl.sCelular;
    edtEmail.Text := uPrincipalOrtoControl.sEmail;
  end;

  edtCodigo.Enabled := false;
  edtNome.SetFocus;

end;

procedure TfrmCadastroCliente.BitBtn2Click(Sender: TObject);
begin
  inherited;
  close;

end;

procedure TfrmCadastroCliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if key = VK_ESCAPE THEN
  close;
end;

end.
