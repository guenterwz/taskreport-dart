final List<Map<String, dynamic>> dadosTarefas = [
  {
    'id': 1,
    'titulo': ' Corrigir bug login ',
    'responsavel': 'Ana',
    'status': 'concluida',
    'prioridade': 'alta',
    'valor': 'R\$ 120,00',
    'horas': '2',
  },
  {
    'id': 2,
    'titulo': 'Criar tela de perfi l',
    'responsavel': ' Bruno ',
    'status': 'em andamento',
    'prioridade': 'media',
    'valor': 'R\$ 250,50',
    'horas': '5',
  },
  {
    'id': 3,
    'titulo': null,
    'responsavel': 'Carla',
    'status': 'pendente',
    'prioridade': 'baixa',
    'valor': 'R\$ 80,00',
    'horas': null,
  },
  {
    'id': 4,
    'titulo': ' Ajustar navegação ',
    'responsavel': null,
    'status': 'concluida',
    'prioridade': 'alta',
    'valor': 'R\$ 150,75',
    'horas': '3',
  },
  {
    'id': 5,
    'titulo': 'Revisar regras de negócio',
    'responsavel': 'Daniel',
    'status': 'cancelada',
    'prioridade': 'media',
    'valor': 'R\$ 0,00',
    'horas': '0',
  },
  {
    'id': 6,
    'titulo': 'Implementar validação de dados',
    'responsavel': 'Eduarda',
    'status': 'concluida',
    'prioridade': 'alta',
    'valor': 'R\$ 200,00',
    'horas': '4',
  },
  {
    'id': 7,
    'titulo': 'Organizar documentação',
    'responsavel': 'Felipe',
    'status': 'pendente',
    'prioridade': 'baixa',
    'valor': 'R\$ 90,00',
    'horas': '2',
  },
];

class ItemTrabalho {  //  RF13 – Criar classe base e classe filha
  int id;
  String titulo;
  ItemTrabalho({required this.id, required this.titulo});
  void exibirResumo() {
    print('Item $id - $titulo');
  }
}

class Tarefa extends ItemTrabalho {
  //  RF01 – Transformar mapas em objetos
  int id;
  String titulo;
  String responsavel;
  String status;
  String prioridade;
  double valor;
  int horas;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.responsavel,
    required this.status,
    required this.prioridade,
    required this.valor,
    required this.horas,
  }) : super(id: id, titulo: titulo);

  factory Tarefa.doMapa(Map<String, dynamic> m) {
    return Tarefa(
      id: m['id'],
      titulo: m['titulo'] != null
          ? m['titulo'].toString().trim()
          : 'Sem título',
      responsavel:
          m['responsavel'] != null //  RF02 – Tratar campos nulos
          ? m['responsavel'].toString().trim()
          : 'Não informado',
      horas: m['horas'] != null ? int.tryParse(m['horas'].toString()) ?? 0 : 0,  //  RF05 – Converter horas para número inteiro
      prioridade: m['prioridade'] != null
          ? m['prioridade'].toString().trim()
          : 'sem prioridade',
      status: m['status'] != null
          ? m['status'].toString().trim()
          : 'sem status',
      valor: m['valor'] != null ? converterValor(m['valor']) : 0.0,
    );
  }

  @override
  void exibirResumo() {
    print('ID: $id\nTitulo: $titulo\nResponsavel: $responsavel\nStatus: $status\nPrioridade: $prioridade\nValor: R\$ $valor\nHoras: $horas\n\n');
  }
}

/*
Tarefa converterMapParaTarefa(Map<String, dynamic> m) {
  return Tarefa(
    id: m['id'],
    titulo: m['titulo'] ?? 'Sem título',
    responsavel: m['responsavel'] ?? 'Não informado',
    status: m['status'] ?? 'sem status',
    prioridade: m['prioridade'] ?? 'sem prioridade',
    valor: converterValor(m['valor']),
    horas: m['horas'] != null ? int.tryParse(m['horas'].toString()) ?? 0 : 0,
  );
}
*/

double converterValor(dynamic valor) {  //  RF04 – Converter valor monetário para número
  if (valor == null) {
    return 0.0;
  }

  String valorTexto = valor.toString();
  valorTexto = valorTexto.replaceAll('R\$', '');
  valorTexto = valorTexto.replaceAll(' ', '');
  valorTexto = valorTexto.replaceAll(',', '.');
  return double.tryParse(valorTexto) ?? 0;
}

void main() {
  List<Tarefa> lista = dadosTarefas.map((map) => Tarefa.doMapa(map)).toList();

  for(var item in lista){  //  RF06 – Exibir todas as tarefas convertidas
      item.exibirResumo();
  }

  print('\nTarefas filtradas por status');//  RF07 – Filtrar tarefas por status

  List<Tarefa> concluidas = lista.where((lista) => lista.status == 'concluida').toList();
  print('\nConcluidas:');
  concluidas.forEach((concluidas) => print('-  ${concluidas.titulo}'));

  List<Tarefa> emAndamento = lista.where((lista) => lista.status == 'em andamento').toList();
  print('\nEm Andamento:');
  emAndamento.forEach((emAndamento) => print('- ${emAndamento.titulo}'));

  List<Tarefa> pendente = lista.where((lista) => lista.status == 'pendente').toList();
  print('\nPendentes:');
  pendente.forEach((pendente) => print('- ${pendente.titulo}'));

  List<Tarefa> cancelada = lista.where((lista) => lista.status == 'cancelada').toList();
  print('\nCancelada:');
  cancelada.forEach((cancelada) => print('- ${cancelada.titulo}'));

}
