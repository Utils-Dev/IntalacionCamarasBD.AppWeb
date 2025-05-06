using BD.AppWeb.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;

namespace BD.AppWeb.Data
{
    public class AppDBContext : DbContext
    {
        public AppDBContext(DbContextOptions<AppDBContext> options)
            : base(options)
        {
        }

        public DbSet<Estado> Estados { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Estado>(entity =>
            {
                entity.ToTable("Estados", "Configuracion");
                entity.HasKey(e => e.IdEstado);
                 entity.Property(e => e.IdEstado).HasColumnName("Código");
                entity.Property(e => e.Nombre).HasColumnName("Nombre")
                    .IsRequired()
                    .HasMaxLength(50);
            });

        }
    }
}
