using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Veterinary_clinic.Models;

#nullable disable

namespace Veterinary_clinic.DB
{
    public partial class ClinicContext : DbContext
    {
        public ClinicContext()
        {
        }

        public ClinicContext(DbContextOptions<ClinicContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Animal> Animals { get; set; }
        public virtual DbSet<Appointment> Appointments { get; set; }
        public virtual DbSet<AppointmentsHistory> AppointmentsHistories { get; set; }
        public virtual DbSet<Client> Clients { get; set; }
        public virtual DbSet<Doctor> Doctors { get; set; }
        public virtual DbSet<Login> Logins { get; set; }
        public virtual DbSet<Service> Services { get; set; }
        public virtual DbSet<DoctorFreq> DoctorFreqs { get; set; }
        public virtual DbSet<App> Apps { get; set; }
        public virtual DbSet<IntReturn> BasicIntDto { get; set; }



        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Data Source=localhost,1433;Initial Catalog=Clinic;Persist Security Info=True;User ID=SA;Password=parolaAiaPuternic4!");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<IntReturn>().HasNoKey();
            modelBuilder.HasAnnotation("Relational:Collation", "SQL_Latin1_General_CP1_CI_AS");

            modelBuilder.Entity<Animal>(entity =>
            {
                entity.Property(e => e.AnimalId).HasColumnName("animal_id");

                entity.Property(e => e.Age).HasColumnName("age");

                entity.Property(e => e.ClientId).HasColumnName("client_id");

                entity.Property(e => e.Height).HasColumnName("height");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("name");

                entity.Property(e => e.Weight).HasColumnName("weight");

                entity.HasOne(d => d.Client)
                    .WithMany(p => p.Animals)
                    .HasForeignKey(d => d.ClientId)
                    .HasConstraintName("FK_Animals_Clients");
            });

            modelBuilder.Entity<Appointment>(entity =>
            {
                entity.Property(e => e.AppointmentId).HasColumnName("appointment_id");

                entity.Property(e => e.AnimalId).HasColumnName("animal_id");

                entity.Property(e => e.Data)
                    .HasColumnType("datetime")
                    .HasColumnName("data");

                entity.Property(e => e.ServiceId).HasColumnName("service_id");

                entity.HasOne(d => d.Animal)
                    .WithMany(p => p.Appointments)
                    .HasForeignKey(d => d.AnimalId)
                    .HasConstraintName("FK_Appointments_Animals");
            });

            modelBuilder.Entity<AppointmentsHistory>(entity =>
            {
                entity.ToTable("Appointments_History");

                entity.Property(e => e.Id)
                    .ValueGeneratedNever()
                    .HasColumnName("id");

                entity.Property(e => e.AnimalName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("animal_name");

                entity.Property(e => e.ClientId).HasColumnName("client_id");

                entity.Property(e => e.Date)
                    .HasColumnType("date")
                    .HasColumnName("date");

                entity.Property(e => e.DoctorName)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("doctor_name");

                entity.Property(e => e.Service)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("service");
            });

            modelBuilder.Entity<Client>(entity =>
            {
                entity.HasIndex(e => e.Cnp, "Unique_Clients")
                    .IsUnique();

                entity.Property(e => e.ClientId).HasColumnName("client_id");

                entity.Property(e => e.Cnp)
                    .IsRequired()
                    .HasMaxLength(15)
                    .IsUnicode(false)
                    .HasColumnName("CNP");

                entity.Property(e => e.FirstName)
                    .HasMaxLength(20)
                    .IsUnicode(false)
                    .HasColumnName("first_name");

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(25)
                    .IsUnicode(false)
                    .HasColumnName("last_name");

                entity.Property(e => e.LoginId).HasColumnName("login_id");

                entity.HasOne(d => d.Login)
                    .WithMany(p => p.Clients)
                    .HasForeignKey(d => d.LoginId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Clients_Login");
            });

            modelBuilder.Entity<Doctor>(entity =>
            {
                entity.Property(e => e.DoctorId).HasColumnName("doctor_id");

                entity.Property(e => e.FirstName)
                    .HasMaxLength(20)
                    .IsUnicode(false)
                    .HasColumnName("first_name");

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(25)
                    .IsUnicode(false)
                    .HasColumnName("last_name");

                entity.Property(e => e.Specialization)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("specialization");
            });

            modelBuilder.Entity<Login>(entity =>
            {
                entity.ToTable("Login");

                entity.HasIndex(e => e.Username, "Unique_Login")
                    .IsUnique();

                entity.Property(e => e.LoginId).HasColumnName("login_id");

                entity.Property(e => e.Password)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("password");

                entity.Property(e => e.Username)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("username");
            });

            modelBuilder.Entity<Service>(entity =>
            {
                entity.HasIndex(e => e.ServiceId, "IX_Services");

                entity.Property(e => e.ServiceId).HasColumnName("service_id");

                entity.Property(e => e.DoctorId).HasColumnName("doctor_id");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("name");

                entity.HasOne(d => d.Doctor)
                    .WithMany(p => p.Services)
                    .HasForeignKey(d => d.DoctorId)
                    .HasConstraintName("FK_Services_Doctors");
            });
          
            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);

        public DbSet<Veterinary_clinic.Models.DoctorFreq> DoctorFreq { get; set; }
    }
}
