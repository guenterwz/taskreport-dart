// Base de dados simulada
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

//  RF13 – Criar classe base e classe filha
class ItemTrabalho {  
  int id;
  String? titulo;
  ItemTrabalho({required this.id, required this.titulo});
  void exibirResumo() {
    print('Item $id - $titulo');
  }
}

//  RF01 – Transformar mapas em objetos
class Tarefa extends ItemTrabalho {  
  int id;
  String? titulo;
  String? responsavel;
  String? status;
  String? prioridade;
  double valor;
  int? horas;

    Tarefa({
    required this.id,
    this.titulo,
    this.responsavel,
    this.status,
    this.prioridade,
    required this.valor,
    this.horas,
  }) : super(id: id, titulo: titulo);

  factory Tarefa.doMapa(Map<String, dynamic> m) {
    return Tarefa(
      id: m['id'],
      titulo: m['titulo'] != null
          ? m['titulo'].toString().trim()  //  RF03 – Remover espaços desnecessários
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

//  RF04 – Converter valor monetário para número
double converterValor(dynamic valor) {  
  if (valor == null) {
    return 0.0;
  }

  String valorTexto = valor.toString();
  valorTexto = valorTexto.replaceAll('R\$', '');
  valorTexto = valorTexto.replaceAll(' ', '');
  valorTexto = valorTexto.replaceAll(',', '.');
  return double.tryParse(valorTexto) ?? 0;
}

//  RF14 – Aplicar encapsulamento
class RelatorioTarefas {
  final List<Tarefa> _tarefas;
  RelatorioTarefas(List<Tarefa> tarefas): _tarefas = tarefas;
  int get quantidadeTotal => _tarefas.length;
}

void main() {
  List<Tarefa> lista = dadosTarefas.map((map) => Tarefa.doMapa(map)).toList();

  //  RF06 – Exibir todas as tarefas convertidas
  for(var item in lista){  
      item.exibirResumo();
  }

  //  RF07 – Filtrar tarefas por status
  print('\nTarefas filtradas por status');

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

  //  RF08 – Somar valores das tarefas concluídas
  double somaConcluidas = concluidas.map((m) => m.valor).reduce((a, b) => a + b);  
  print('\nTotal de tarefas concluidas: R\$ $somaConcluidas');

  //  RF09 – Calcular média de valor das tarefas pendentes
  double somaPendentes = pendente.map((m) => m.valor).reduce((a, b) => a + b);
  double mediaPendentes = 0.0;
  try{  //  Tratamento de exceções
    mediaPendentes = somaPendentes / pendente.length;
  } catch (e) {
    print('Erro: $e');
  }
  print(mediaPendentes > 0.0 ? '\nMedia de valor das tarefas pendentes: $mediaPendentes' : '\nNão existem tarefas pendentes para calcular média.');

  //  RF10 – Calcular total de horas por status
  Map<String, int> tempoPorStatus = {};
  for (Tarefa t in lista) {
    String status = t.status ?? 'Sem status';
    tempoPorStatus[status] = (tempoPorStatus[status] ?? 0) + (t.horas ?? 0);
  }

  print('\nHoras por status:');
  tempoPorStatus.forEach((status, horas) => print('- $status: $horas horas'));

  //  RF11 – Identificar tarefas com dados incompletos
  print('\nTarefas com dados incompletos:');
  List<String> incompletas = [];
  for(Map<String, dynamic> t in dadosTarefas){
    if(t['titulo'] == null) incompletas.add('- ID: ${t['id']} : Titulo ausente.');
    if(t['responsavel'] == null) incompletas.add('- ID: ${t['id']} : Responsavel ausente.');
    if(t['status'] == null) incompletas.add('- ID: ${t['id']} : Status ausente.');
    if(t['valor'] == null) incompletas.add('- ID: ${t['id']} : Valor ausente.');
    if(t['horas'] == null) incompletas.add('- ID: ${t['id']} : Tempo em horas ausente.');
    if(t['prioridade'] == null) incompletas.add('- ID: ${t['id']} : Prioridade ausente');
  }
  incompletas.forEach((i) => print(i));

  //  RF12 – Exibir status únicos usando Set
  print('\nLista de status únicos:');
  Set<String> statusUnicos = {};
  for (Tarefa t in lista) {
    statusUnicos.add(t.status ?? 'Sem status');
  }
  statusUnicos.forEach((s) => print('- $s'));

  //  RF15 – Gerar relatório final
  print('=========================================================');
  RelatorioTarefas r = RelatorioTarefas(lista);
  
  print('\nRELATÓRIO FINAL DE TAREFAS\n');
  print('\nTotal de tarefas analisadas: ${r.quantidadeTotal}');
  print('Tarefas concluidas: ${concluidas.length}');
  print('Tarefas pendentes: ${pendente.length}');
  print('Tarefas em andamento: ${emAndamento.length}');
  print('Tarefas canceladas: ${cancelada.length}');
  print('\nValor total das concluidas: R\$ $somaConcluidas');
  print('Média de valor das pendentes: R\$ $mediaPendentes');
  int? totalHorasConcluidas = concluidas.map((m) => m.horas).reduce((a, b) => a! + b!);
  print('Total de horas concluidas: $totalHorasConcluidas');
  print('\nStatus encontrados:');
  statusUnicos.forEach((s) => print('- $s'));
  print('\nTarefas com dados incompletos:');
  incompletas.forEach((i) => print(i));
}
