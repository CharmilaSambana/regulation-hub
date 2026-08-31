
CREATE POLICY "teacher uploads own materials files" ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'materials' AND (storage.foldername(name))[1] = auth.uid()::text AND public.has_role(auth.uid(),'teacher'));
CREATE POLICY "teacher updates own materials files" ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id = 'materials' AND (storage.foldername(name))[1] = auth.uid()::text);
CREATE POLICY "teacher deletes own materials files" ON storage.objects FOR DELETE TO authenticated
  USING (bucket_id = 'materials' AND (storage.foldername(name))[1] = auth.uid()::text);

DROP POLICY IF EXISTS "profiles readable by authenticated" ON public.profiles;

CREATE POLICY "own profile readable"
ON public.profiles FOR SELECT TO authenticated
USING (auth.uid() = id);

CREATE POLICY "teacher profiles readable"
ON public.profiles FOR SELECT TO authenticated
USING (public.has_role(id, 'teacher'::app_role));

CREATE POLICY "materials readable by owner or matching student"
ON storage.objects FOR SELECT TO authenticated
USING (
  bucket_id = 'materials'
  AND EXISTS (
    SELECT 1 FROM public.materials m
    WHERE m.file_path = storage.objects.name
      AND (
        m.teacher_id = auth.uid()
        OR EXISTS (
          SELECT 1 FROM public.profiles p
          WHERE p.id = auth.uid() AND p.regulation = m.regulation
        )
      )
  )
);
