using CadConsultorioCardiologia;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClnConsultorioCardiologia
{
    public class HistorialCln
    {
        public static int insertar(Historial historial)
        {
            using (var context = new BDConsultorioCardiologiaEntities())
            {
                context.Historial.Add(historial);
                context.SaveChanges();
                return historial.id;
            }
        }

        public static int actualizar(Historial historial)
        {
            using (var context = new BDConsultorioCardiologiaEntities())
            {
                var existente = context.Historial.Find(historial.id);
                existente.diagnostico = historial.diagnostico;
                existente.observaciones = historial.observaciones;
                existente.fecha = historial.fecha;
                //existente.estado = historial.estado;
                existente.usuarioRegistro = historial.usuarioRegistro;
                return context.SaveChanges();
            }
        }

        public static int eliminar(int id, string usuarioRegistro)
        {
            using (var context = new BDConsultorioCardiologiaEntities())
            {
                var existente = context.Historial.Find(id);
                existente.estado = -1;
                existente.usuarioRegistro = usuarioRegistro;
                return context.SaveChanges();
            }
        }

        public static Historial get(int id)
        {
            using (var context = new BDConsultorioCardiologiaEntities())
            {
                return context.Historial.Find(id);
            }
        }

        public static List<Historial> listar()
        {
            using (var context = new BDConsultorioCardiologiaEntities())
            {
                return context.Historial.Where(x => x.estado != -1).ToList();
            }
        }

        public static List<paHistorialListar_Result> listarPa(string parametro4)
        {
            using (var context = new BDConsultorioCardiologiaEntities())
            {
                return context.paHistorialListar(parametro4).ToList();
            }
        }
    }
}

