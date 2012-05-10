package Acao::Model::Schema;
use Net::LDAP;
use Moose;
use Data::Dumper;
use strict;
use warnings;
use List::MoreUtils qw{uniq};
use XML::LibXML;
use XML::Compile::Schema;
use XML::Compile::Util;

use Carp qw(croak);
extends 'Acao::Model::LDAP';

sub listar_schemas {
    my ( $self, $args ) = @_;
    my $busca;
    if ($args->{busca}) {
        $busca = 'where $x/xs:element/xs:annotation/xs:appinfo/class:classificacoes/class:classificacao/text() = '
               . '"'. $args->{busca} . '"';
    }

    my $list = 'declare namespace class = "http://schemas.fortaleza.ce.gov.br/acao/classificacao.xsd";'
             . 'subsequence('
             . 'for $x in collection("acao-schemas")/xs:schema '.$busca
             . 'order by $x/xs:element/xs:annotation/xs:appinfo/class:classificacoes/@validacao/string() '
             . ' return ($x,'
             . $args->{grid}
             . '  ), ('
             . $args->{interval_ini} * $args->{num_por_pagina}
             . ') + 1 ,'
             . $args->{num_por_pagina} . '' . ')';

    my $count = 'declare namespace class = "http://schemas.fortaleza.ce.gov.br/acao/classificacao.xsd";'
              . 'count('
              . 'for $x in collection("acao-schemas")/xs:schema '.$busca
              . ' return "")';

    return {
        list  => $list,
        count => $count
    };

}

sub options_classificacao_xsd {
    my ($self) = @_;

    my $query = q|declare namespace class = "http://schemas.fortaleza.ce.gov.br/acao/classificacao.xsd";
                  for $x in collection("acao-schemas")/xs:schema/xs:element/xs:annotation/xs:appinfo/class:classificacoes
                  return  (for $x in ($x/class:classificacao) return $x/text())|;

    $self->sedna->begin();
    $self->sedna->execute($query);

    my %hash;
    my $options;

    while ( my $item = $self->sedna->get_item() ) {
        $item =~ s/^\s+//go;
        my $value = $item;
        $value =~ s/cn=//go;
        $hash{$item} = $value;
    }

    for my $k (sort keys %hash) {
        
        $options .= qq|<option value="$k">$hash{$k}</option>\n|;
    }

    $self->sedna->commit;

    return $options;
}

sub insere_schema {
    my ($self, $collection,$target,$documentoXsd) = @_;

    my $query =
    'LOAD "'.$target.'" "'.$documentoXsd.'" "'.$collection.'" ';

    $self->sedna->begin();

    eval {
      $self->sedna->execute($query);
    };

    $self->sedna->commit;
    return 1;

}


sub altera_validacao_schemas {
    my ($self, $XSDtargetNamespace, $validacao) = @_;

    my $query = ' declare namespace class = "http://schemas.fortaleza.ce.gov.br/acao/classificacao.xsd"; '
              . ' update replace $x in collection("acao-schemas")[xs:schema/@targetNamespace/string()="'.$XSDtargetNamespace.'"] '
              . ' /xs:schema/xs:element/xs:annotation/xs:appinfo/class:classificacoes '
              . ' with <class:classificacoes validacao="'.$validacao.'">{$x/class:classificacao}</class:classificacoes> ';

    $self->sedna->begin();
    $self->sedna->execute($query);
    $self->sedna->commit;

    return;
}

sub verifica_schemas {
    my ($self, $XSDtargetNamespace) = @_;
    my @id_volumes;
    my $countTNS = 0;
    my $query = ' declare namespace xs = "http://schemas.fortaleza.ce.gov.br/acao/volume.xsd"; '
              . ' declare namespace audt="http://schemas.fortaleza.ce.gov.br/acao/auditoria.xsd"; '
              . ' for $x in collection("volume") '
              . ' return $x/xs:volume/xs:collection/text() ';

    $self->sedna->begin();
    $self->sedna->execute($query);
    
    while ( my $item = $self->sedna->get_item() ) {
        $item =~ s/^\s+//go;
        push @id_volumes, $item;
    }

    for my $id_volume ( @id_volumes ) { 
        my $xq = ' declare namespace dos = "http://schemas.fortaleza.ce.gov.br/acao/dossie.xsd"; '
               . ' declare namespace doc = "http://schemas.fortaleza.ce.gov.br/acao/documento.xsd"; '
               . ' count(for $x in collection("'.$id_volume.'")/dos:dossie/dos:doc/doc:documento/doc:documento/doc:conteudo/* '
               . ' where namespace-uri($x) eq "'.$XSDtargetNamespace.'"'
               . ' return "") ';

        $self->sedna->execute($xq);
        $countTNS = $self->sedna->get_item();
        last if $countTNS;
        
    }

    $self->sedna->commit;    
    
    return $countTNS;
}

sub substituir_schema {
    my ($self, $collection, $target, $documentoXsd) = @_;

    $documentoXsd =~ s/^.*\///go;
    my $query = 'DROP DOCUMENT "'.$documentoXsd.'" IN COLLECTION "'.$collection.'"';

    $self->sedna->begin();

    eval {
      $self->sedna->execute($query);
    };
    $self->sedna->commit;

    $self->insere_schema( $collection, $target, $documentoXsd );
    return 1;

}

sub excluir_schema {
    my ($self, $collection, $XSDtargetNamespace) = @_;
    my @docs;
    my $target;

    my $query = 'doc("$documents")/documents/collection[@name="acao-schemas"]';

    $self->sedna->begin();

    eval {
        $self->sedna->execute($query);
        while ( my $doc = $self->sedna->get_item() ) { 
            $doc =~ s/qw|<document name="|//go;
            $doc =~ s/qw|"\/>|//go;
            $doc =~ s/qw|<collection name="acao-schemas">|//go;
            $doc =~ s/qw|<\/collection>|//go;
            $doc =~ s/\n//go;
            $doc =~ s/^\s*//go;
            @docs = split('  ', $doc);
        }
    };
    $self->sedna->commit;

    foreach my $doc(@docs){
        $query = 'data(fn:doc("'.$doc.'", "acao-schemas")//@targetNamespace)';
        $self->sedna->begin();

        eval {
          $self->sedna->execute($query);
          if($self->sedna->get_item()  eq $XSDtargetNamespace){
            my $drop = 'DROP DOCUMENT "'.$doc.'" IN COLLECTION "'.$collection.'"';
            $self->sedna->execute($drop);
          }
        };
        $self->sedna->commit;
    }

    return 1;
}

1;
