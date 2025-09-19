-- Crear la tabla resource_permissions
CREATE TABLE public.resource_permissions (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  role_id bigint NOT NULL,
  resource_path text NOT NULL,
  can_access boolean DEFAULT true NOT NULL,
  CONSTRAINT resource_permissions_pkey PRIMARY KEY (id),
  CONSTRAINT resource_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Habilitar Row Level Security para resource_permissions
ALTER TABLE public.resource_permissions ENABLE ROW LEVEL SECURITY;

-- Política RLS: Permitir a los usuarios autenticados leer los permisos de recursos
-- Esto es importante para que el frontend pueda consultar qué rutas son accesibles.
CREATE POLICY "Allow authenticated users to read resource permissions"
ON public.resource_permissions FOR SELECT
TO authenticated
USING (true);

-- Opcional: Añadir un índice para mejorar el rendimiento de las consultas
CREATE INDEX idx_resource_permissions_role_id ON public.resource_permissions (role_id);
CREATE INDEX idx_resource_permissions_resource_path ON public.resource_permissions (resource_path);
