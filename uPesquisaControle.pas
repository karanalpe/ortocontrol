unit uPesquisaControle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uCadastroPadrao, Grids, DBGrids, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, StdCtrls, Buttons, ExtCtrls, jpeg;

type
  TfrmPesquisaControle = class(TfrmCadastroPadrao)
    DBGrid1: TDBGrid;
    Label2: TLabel;
    edtPaciente: TEdit;
    Label3: TLabel;
    edtCliente: TEdit;
    Label4: TLabel;
    edtAparelho: TEdit;
    btnFiltrar: TButton;
    qryPadraoCdigo: TIntegerField;
    qryPadraoPaciente: TStringField;
    qryPadraoCliente: TStringField;
    qryPadraoAparelho: TStringField;
    procedure btnFiltrarClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCodigoExit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure PesquisaControle;
  end;

var
  frmPesquisaControle: TfrmPesquisaControle;

implementation
uses uPrincipalOrtoControl;
{$R *.dfm}

procedure TfrmPesquisaControle.btnFiltrarClick(Sender: TObject);
begin
  inherited;
    PesquisaControle;
    DBGrid1.SetFocus;
end;

procedure TfrmPesquisaControle.BitBtn2Click(Sender: TObject);
begin
  inherited;
  close;
end;

procedure TfrmPesquisaControle.FormShow(Sender: TObject);
begin
  inherited;
  PesquisaControle;
  edtCodigo.SetFocus;
end;

procedure TfrmPesquisaControle.edtCodigoExit(Sender: TObject);
begin
  inherited;
  edtPaciente.SetFocus;
end;

procedure TfrmPesquisaControle.BitBtn1Click(Sender: TObject);
begin
  inherited;
  uPrincipalOrtoControl.iCodigoCliente := qryPadrao.FieldByName('C�digo').AsInteger;
  frmPrincipalOrtoControl.ChamadaFrameControle;
  close;
end;

procedure TfrmPesquisaControle.PesquisaControle;
begin
  with qryPadrao do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select c.i_cod_controle "C�digo",                                                       ');
    SQL.Add('       c.s_nome_paciente_controle "Paciente",                                           ');
    SQL.Add('       cl.s_nome_cliente "Cliente",                                                     ');
    SQL.Add('       c.s_descricao_aparelho_controle "Aparelho"                                       ');
    SQL.Add('from controle c                                                                         ');
    SQL.Add('     inner join cliente cl                                                              ');
    SQL.Add('       on (c.i_cod_cliente = cl.i_cod_cliente)                                          ');
    SQL.Add('where c.s_nome_paciente_controle like ' + QuotedStr('%' + edtPaciente.Text + '%')        );
    if edtCodigo.Text <> '' then
    SQL.Add('  and c.i_cod_controle = ' + edtCodigo.Text                                              );
    SQL.Add('  and cl.s_nome_cliente like ' + QuotedStr('%' + edtCliente.Text + '%')                  );
    SQL.Add('  and c.s_descricao_aparelho_controle like ' + QuotedStr('%' + edtAparelho.Text + '%')   );
    SQL.Add('order by (c.i_cod_controle)                                                             ');
    Open;
  end;

end;

procedure TfrmPesquisaControle.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if key = VK_ESCAPE THEN
  close;
end;

end.

