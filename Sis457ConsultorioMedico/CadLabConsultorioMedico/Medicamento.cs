//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CadLabConsultorioMedico
{
    using System;
    using System.Collections.Generic;
    
    public partial class Medicamento
    {
        public int id { get; set; }
        public int idPaciente { get; set; }
        public string articulo { get; set; }
        public string descripcion { get; set; }
        public decimal precio { get; set; }
        public string usuarioRegistro { get; set; }
        public System.DateTime fechaRegistro { get; set; }
        public short estado { get; set; }
    
        public virtual Paciente Paciente { get; set; }
    }
}
