import { fileIo as fs } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { buffer } from '@kit.ArkTS';

const context = getContext(this) as common.UIAbilityContext;
const filesDir = context.filesDir;
const filePath = filesDir + "/history.json";

interface BrowseRecord {
  userid: number;
  artifactids: number[];
}

let records: BrowseRecord[] = readRecords();

function readRecords(): BrowseRecord[] {
  const file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  try {
    const stat = fs.statSync(filePath);
    if (stat.size > 0) {
      const buf = new ArrayBuffer(stat.size);
      fs.readSync(file.fd, buf);
      const text = buf.toString();
      const list = JSON.parse(text) as BrowseRecord[];
      return list;
    }
  } catch (err) {
    console.error('readHistory error:', err);
  } finally {
    fs.closeSync(file);
  }
  return [];
}

function saveRecords(records: BrowseRecord[]): void {
  const path = filesDir + '/history.json';
  const file = fs.openSync(
    path,
    fs.OpenMode.WRITE_ONLY |
    fs.OpenMode.CREATE |
    fs.OpenMode.TRUNC
  );
  try {
    const json = JSON.stringify(records);
    const buf = new Uint8Array(buffer.from(json, 'utf-8').buffer);
    fs.writeSync(file.fd, buf);
  } catch (err) {
    console.error('saveHistory error:', err);
  } finally {
    fs.closeSync(file);
  }
}

function removeIdAt(ids: number[], i: number): number[] {
  if (i >= 0 && i < ids.length) {
    ids.splice(i, 1);
  }
  return ids;
}

export function addHistoryRecord(userId: number, artifactId: number) {
  let userRecord: BrowseRecord = {
    userid: userId,
    artifactids: []
  };
  let found = false;

  for (let i = 0; i < records.length; i++) {
    const record = records[i];
    if (record.userid == userId) {
      userRecord = record;
      found = true;
      break;
    }
  }

  for (let i = 0; i < userRecord.artifactids.length; i++) {
    const id = userRecord.artifactids[i];
    if (id == artifactId) {
      userRecord.artifactids = removeIdAt(userRecord.artifactids, i);
      break;
    }
  }
  userRecord.artifactids.push(artifactId);

  if (!found) {
    records.push(userRecord);
  }
  saveRecords(records);
}

export function getArtifactIdsByUserId(userId: number): number[] {
  for (let i = 0; i < records.length; i++) {
    const record = records[i];
    if (record.userid == userId) {
      return record.artifactids;
    }
  }
  return [];
}
