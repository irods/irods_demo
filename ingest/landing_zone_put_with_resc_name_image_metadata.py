# landing_zone_put_with_resc_name_image_metadata.py 
import exifread
import os, shutil
from irods_capability_automated_ingest.core import Core
from irods_capability_automated_ingest.utils import Operation
def add_exif_metadata(session, target, path):
    with open(path, 'rb') as f:
        obj = session.data_objects.get(target)
        try:
            tags = exifread.process_file(f, details=False)
            for (k, v) in tags.items():
                if k not in ('JPEGThumbnail','TIFFThumbnail','Filename','EXIF MakerNote'):
                    if k in obj.metadata.keys():
                        obj.metadata[k] = iRODSMeta(k, v)
                    else:
                        obj.metadata.add(str(k), str(v), '')
        except:
            pass
class event_handler(Core):
    @staticmethod
    def to_resource(session, meta, **options):
        return "demoResc"
    @staticmethod
    def operation(session, meta, **options):
        return Operation.PUT
    @staticmethod
    def post_data_obj_create(hdlr_mod, logger, session, meta, **options):
        path = meta['path']
        add_exif_metadata(session, meta['target'], meta['path'])
        new_path = path.replace('/tmp/landing_zone', '/tmp/ingested')
        try:
            dir_name = os.path.dirname(new_path)
            os.makedirs(dir_name, exist_ok=True)
            shutil.move(path, new_path)
        except:
            logger.info('FAILED to move ['+path+'] to ['+new_path+']')

