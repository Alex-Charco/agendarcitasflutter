import 'package:agendarcitasflutter/services/api_service.dart';
import 'package:flutter/material.dart';
import '../models/turno.dart';
import '../widgets/modal_registrar_cita.dart';
import 'package:agendarcitasflutter/utils/dialog_utils.dart';

class TurnosPage extends StatefulWidget {
  const TurnosPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TurnosPageState createState() => _TurnosPageState();
}

class _TurnosPageState extends State<TurnosPage> {
  List<Turno> turnos = [];
  List<Turno> filteredTurnos = [];
  final TextEditingController filterController = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTurnos();
    filterController.addListener(_filterTurnos);
  }

  void _filterTurnos() {
    final query = filterController.text.toLowerCase();
    setState(() {
      filteredTurnos = turnos.where((t) =>
        t.medico.medico.toLowerCase().contains(query) ||
        t.medico.especialidad.toLowerCase().contains(query) ||
        t.fecha.contains(query) ||
        t.hora.contains(query)
      ).toList();
    });
  }

  Future<void> fetchTurnos() async {
    setState(() => loading = true);
    try {
  turnos = await ApiService.getTurnos();
  if (turnos.isNotEmpty) {
    // ignore: avoid_print
    print('Primer turno: ${turnos[0].fecha} - ${turnos[0].hora}');
  }
  filteredTurnos = turnos;
} catch (e) {
  // ignore: avoid_print
  print('Error al obtener turnos: $e');
}
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 244, 246),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 237, 241, 245),
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Turnos disponibles',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                  controller: filterController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search), 
                    labelText: 'Filtrar turnos...',
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), 
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTurnos.length,
                    itemBuilder: (context, index) {
                      final turno = filteredTurnos[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRow(
                                icon: Icons.calendar_today,
                                label: 'Fecha:',
                                value: turno.fecha,
                                iconColor: Colors.blue,
                              ),
                              _buildRow(
                                icon: Icons.access_time,
                                label: 'Hora:',
                                value: turno.hora,
                                iconColor: Colors.green,
                              ),
                              _buildRow(
                                icon: Icons.person,
                                label: 'Médico:',
                                value: turno.medico.medico,
                                iconColor: Colors.orange,
                              ),
                              _buildRow(
                                icon: Icons.local_hospital,
                                label: 'Especialidad:',
                                value: turno.medico.especialidad,
                                iconColor: Colors.purple,
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (_) => ModalRegistrarCita(
                                      turno: turno,
                                      onConfirm: () async {
                                        await ApiService.registrarCita(context, turno.idTurno);
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        // ignore: use_build_context_synchronously
                                        showSuccessDialog(context, 'Éxito', 'Cita registrada con éxito');
                                        fetchTurnos();
                                      },
                                    ),
                                  ),
                                  child: const Text('Registrar Cita'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
			  crossAxisAlignment: CrossAxisAlignment.start,
			  children: [
				Icon(icon, size: 20, color: iconColor),
				const SizedBox(width: 8),
				Flexible(
				  child: Text(
					label,
					style: const TextStyle(fontWeight: FontWeight.bold),
					overflow: TextOverflow.ellipsis,
					softWrap: false,
				  ),
				),
				const SizedBox(width: 4),
				Expanded(
				  child: Text(
					value,
					overflow: TextOverflow.ellipsis,
				  ),
				),
			  ],
			)

    );
  }
}
