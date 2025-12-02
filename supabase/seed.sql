-- Enable extensions
create extension if not exists "pg_cron" with schema extensions;
create extension if not exists "uuid-ossp";

-- === TABLES ===
create table if not exists locations (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  address text,
  created_at timestamp default now()
);

create table if not exists guards (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  email text unique,
  phone text,
  tier integer default 1,
  is_available boolean default true,
  created_at timestamp default now()
);

create table if not exists shifts (
  id uuid primary key default uuid_generate_v4(),
  location_id uuid references locations(id),
  start_time timestamp not null,
  end_time timestamp not null,
  required_guards integer default 1,
  status text default 'open',
  created_at timestamp default now()
);

create table if not exists assignments (
  id uuid primary key default uuid_generate_v4(),
  shift_id uuid references shifts(id),
  guard_id uuid references guards(id),
  status text default 'pending',
  responded_at timestamp,
  created_at timestamp default now(),
  unique(shift_id, guard_id)
);

create table if not exists emergency_logs (
  id uuid primary key default uuid_generate_v4(),
  shift_id uuid references shifts(id),
  message text,
  tier integer,
  sent_to uuid[],
  responded_by uuid,
  status text,
  timestamp timestamp default now()
);

-- Indexes
create index if not exists idx_shifts_status on shifts(status);
create index if not exists idx_assignments_shift on assignments(shift_id);
create index if not exists idx_assignments_guard on assignments(guard_id);

-- === SEED DATA ===

-- Locations (10)
INSERT INTO locations (name, address) VALUES
('Amsterdam Centraal', 'Stationsplein 15, 1012 AB Amsterdam'),
('Schiphol Plaza', 'Aankomstpassage 1, 1118 AX Schiphol'),
('Rotterdam Centraal', 'Stationsplein 1, 3013 AJ Rotterdam'),
('Utrecht Centraal', 'Stationshal 12, 3511 CE Utrecht'),
('Den Haag Centraal', 'Stationsweg 1, 2515 BK Den Haag'),
('Eindhoven Centraal', 'Stationsplein 22, 5611 AC Eindhoven'),
('Groningen Centraal', 'Stationsweg 1, 9726 AE Groningen'),
('Tilburg Centraal', 'Spoorlaan 35, 5038 CB Tilburg'),
('Almere Centrum', 'Stationsplein 1, 1315 KT Almere'),
('Zaandam Station', 'Provincialeweg 1, 1506 MA Zaandam')
ON CONFLICT DO NOTHING;

-- Guards (20)
INSERT INTO guards (name, email, phone, tier, is_available) VALUES
('Jan de Vries', 'jan@example.com', '+31612345678', 1, true),
('Anna Bakker', 'anna@example.com', '+31623456789', 1, true),
('Kees Jansen', 'kees@example.com', '+31634567890', 2, true),
('Lisa de Jong', 'lisa@example.com', '+31645678901', 1, true),
('Mark Visser', 'mark@example.com', '+31656789012', 1, false),
('Sophie Mulder', 'sophie@example.com', '+31667890123', 1, true),
('Tom van Dijk', 'tom@example.com', '+31678901234', 1, true),
('Emma Smit', 'emma@example.com', '+31689012345', 1, true),
('Lars Boer', 'lars@example.com', '+31690123456', 1, false),
('Noa Hoekstra', 'noa@example.com', '+31601234567', 1, true),
('Finn Meijer', 'finn@example.com', '+31611234567', 1, true),
('Sara van der Linden', 'sara@example.com', '+31622345678', 1, true),
('Daan de Graaf', 'daan@example.com', '+31633456789', 1, true),
('Lotte van Beek', 'lotte@example.com', '+31644567890', 1, false),
('Sem van Dam', 'sem@example.com', '+31655678901', 1, true),
('Tess van Leeuwen', 'tess@example.com', '+31666789012', 1, true),
('Milan van den Berg', 'milan@example.com', '+31677890123', 1, true),
('Zoë van der Velden', 'zoe@example.com', '+31688901234', 1, true),
('Jelle van der Wal', 'jelle@example.com', '+31699012345', 1, true),
('Fenne van der Heijden', 'fenne@example.com', '+31600123456', 1, true)
ON CONFLICT DO NOTHING;

-- Shifts (30)
INSERT INTO shifts (location_id, start_time, end_time, required_guards, status)
SELECT
  l.id,
  (date || ' ' || start_time)::timestamp,
  (date || ' ' || end_time)::timestamp,
  CASE WHEN required_role = 'Supervisor' THEN 1 ELSE 1 END,
  status
FROM (VALUES
  ('2025-04-05', '08:00', '16:00', 1, 'Security Officer', 'open'),
  ('2025-04-05', '16:00', '00:00', 1, 'Security Officer', 'open'),
  ('2025-04-05', '08:00', '16:00', 2, 'Security Officer', 'filled'),
  ('2025-04-05', '12:00', '20:00', 3, 'Supervisor', 'open'),
  ('2025-04-05', '20:00', '04:00', 4, 'Security Officer', 'open'),
  ('2025-04-06', '08:00', '16:00', 1, 'Security Officer', 'open'),
  ('2025-04-06', '16:00', '00:00', 2, 'Security Officer', 'open'),
  ('2025-04-06', '10:00', '18:00', 5, 'Security Officer', 'filled'),
  ('2025-04-06', '14:00', '22:00', 6, 'Security Officer', 'open'),
  ('2025-04-06', '22:00', '06:00', 7, 'Security Officer', 'open'),
  ('2025-04-07', '08:00', '16:00', 8, 'Security Officer', 'open'),
  ('2025-04-07', '16:00', '00:00', 9, 'Security Officer', 'open'),
  ('2025-04-07', '09:00', '17:00', 10, 'Security Officer', 'filled'),
  ('2025-04-07', '13:00', '21:00', 1, 'Supervisor', 'open'),
  ('2025-04-07', '21:00', '05:00', 2, 'Security Officer', 'open'),
  ('2025-04-05', '10:00', '18:00', 3, 'Security Officer', 'open'),
  ('2025-04-05', '18:00', '02:00', 4, 'Security Officer', 'open'),
  ('2025-04-06', '12:00', '20:00', 5, 'Security Officer', 'open'),
  ('2025-04-06', '20:00', '04:00', 6, 'Security Officer', 'open'),
  ('2025-04-07', '11:00', '19:00', 7, 'Security Officer', 'open'),
  ('2025-04-07', '19:00', '03:00', 8, 'Security Officer', 'open'),
  ('2025-04-05', '14:00', '22:00', 9, 'Security Officer', 'filled'),
  ('2025-04-05', '22:00', '06:00', 10, 'Security Officer', 'open'),
  ('2025-04-06', '08:00', '16:00', 1, 'Security Officer', 'open'),
  ('2025-04-06', '16:00', '00:00', 2, 'Security Officer', 'open'),
  ('2025-04-07', '08:00', '16:00', 3, 'Security Officer', 'open'),
  ('2025-04-07', '16:00', '00:00', 4, 'Security Officer', 'open'),
  ('2025-04-05', '09:00', '17:00', 5, 'Security Officer', 'open'),
  ('2025-04-05', '17:00', '01:00', 6, 'Security Officer', 'open'),
  ('2025-04-06', '13:00', '21:00', 7, 'Security Officer', 'open')
) AS s(date, start_time, end_time, loc_idx, required_role, status)
JOIN locations l ON l.id = (SELECT id FROM locations ORDER BY id LIMIT 1 OFFSET (loc_idx - 1))
ON CONFLICT DO NOTHING;

-- === RLS & POLICIES ===
alter table locations enable row level security;
alter table guards enable row level security;
alter table shifts enable row level security;
alter table assignments enable row level security;
alter table emergency_logs enable row level security;

create policy "public read locations" on locations for select using (true);
create policy "public read guards" on guards for select using (true);
create policy "public read shifts" on shifts for select using (true);
create policy "public read assignments" on assignments for select using (true);
create policy "public read emergency_logs" on emergency_logs for select using (true);

create policy "auth insert assignments" on assignments for insert with check (auth.role() = 'authenticated');
create policy "auth update assignments" on assignments for update using (auth.role() = 'authenticated');
