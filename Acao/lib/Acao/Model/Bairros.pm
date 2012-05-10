package Acao::Model::Bairros;


# Copyright 2010 - Prefeitura Municipal de Fortaleza
#
# Este arquivo é parte do programa Ação - Sistema de Acompanhamento de
# Projetos Sociais
#
# O Ação é um software livre; você pode redistribui-lo e/ou modifica-lo
# dentro dos termos da Licença Pública Geral GNU como publicada pela
# Fundação do Software Livre (FSF); na versão 2 da Licença.
#
# Este programa é distribuido na esperança que possa ser util, mas SEM
# NENHUMA GARANTIA; sem uma garantia implicita de ADEQUAÇÂO a qualquer
# MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a Licença Pública Geral GNU
# para maiores detalhes.
#
# Você deve ter recebido uma cópia da Licença Pública Geral GNU, sob o
# título "LICENCA.txt", junto com este programa, se não, escreva para a
# Fundação do Software Livre(FSF) Inc., 51 Franklin St, Fifth Floor,

use Moose;
extends 'Acao::Model';
use Data::Dumper;
use Encode;
use strict;
use warnings;

sub listaBairros {
	my ($self, $dsc_bairro ) = @_;
	$dsc_bairro = uc($dsc_bairro);
	
	my @bairros;
	my @regional;
	my @result = $self->dbic->resultset('Bairros')->search(
		{ nome => { ilike => '%'.$dsc_bairro.'%' } },
		{ columns => ['nome']},
		{ rows => 30},
	);

	for my $rset (@result) {
		push @bairros, $rset->nome;
	}

	return \@bairros;
}

1;
