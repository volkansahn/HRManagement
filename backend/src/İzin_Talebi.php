<?php


namespace Src;


class İzin_Talebi
{

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function findAll()
    {
        $statement = "
            SELECT 
                *
            FROM
                izin_talebi;
        ";

        try {
            $statement = $this->db->query($statement);
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function find($izin_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                izin_talebi
            WHERE izin_id = :izin_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'izin_id' => $izin_id
            ));
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function findByUser($kullanici_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                izin_talebi
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $kullanici_id
            ));
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function findBekler($bekler_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                izin_talebi
            WHERE bekler_id = :bekler_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'bekler_id' => $bekler_id
            ));
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function insert(array $input)
    {
        $statement = "
            INSERT INTO izin_talebi 
                (izin_turu, kullanici_id, izin_baslangic, izin_bitis, durum_id, bekler_id)
            VALUES
                (:izin_turu, :kullanici_id, :izin_baslangic, :izin_bitis, :durum_id, :bekler_id);
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'izin_turu' => $input['izin_turu'],
                'kullanici_id' => $input['kullanici_id'],
                'izin_baslangic' => $input['izin_baslangic'],
                'izin_bitis' => $input['izin_bitis'],
                'durum_id' => $input['durum_id'],
                'bekler_id' => $input['bekler_id']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function update($izin_id, array $input)
    {
        $statement = "
            UPDATE izin_talebi
            SET 
                kullanici_id = :kullanici_id,
                izin_baslangic  = :izin_baslangic,
                izin_bitis = :izin_bitis,
                durum_id = :durum_id,
                bekler_id = :bekler_id
            
            WHERE izin_id = :izin_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'izin_id' => $izin_id,
                'kullanici_id' => $input['kullanici_id'],
                'izin_baslangic' => $input['izin_baslangic'],
                'izin_bitis' => $input['izin_bitis'],
                'durum_id' => $input['durum_id'],
                'bekler_id' => $input['bekler_id']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function updateOnay(array $input)
    {
        $statement = "
            UPDATE izin_talebi
            SET 
                durum_id = :durum_id,
                bekler_id = :bekler_id
            
            WHERE izin_id = :izin_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'izin_id' => $input['izin_id'],
                'durum_id' => $input['durum_id'],
                'bekler_id' => $input['bekler_id']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function delete($kullanici_id)
    {
        $statement = "
            DELETE FROM izin_talebi
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array('kullanici_id' => $kullanici_id));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }
}